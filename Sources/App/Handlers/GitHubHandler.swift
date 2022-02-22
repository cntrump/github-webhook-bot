//
//  GitHubHandler.swift
//  
//
//  Created by lvv.me on 2022/2/19.
//

import Vapor
import Crypto

private func verifySignature(_ signature: String, for payload: Data, secret token: String) -> Bool {
    guard let tokenData = token.data(using: .utf8) else {
        return false
    }

    let key = SymmetricKey(data: tokenData)
    let data = Data(HMAC<SHA256>.authenticationCode(for: payload, using: key))
    let hexdigest = data.hexEncodedString(uppercase: false)
    let payloadSignature = "sha256=" + hexdigest

    return signature.elementsEqual(payloadSignature)
}

extension Request {
    func getBodyJsonObject() throws -> [String: Any]? {
        guard let bodyData = body.data else {
            return nil
        }

        guard let jsonObject = try JSONSerialization.jsonObject(with: bodyData) as? [String: Any] else {
            return nil
        }

        return jsonObject
    }
}

struct GitHubHandler {

    static func handleEvents(_ req: Request) throws -> String {
        guard let event = req.headers.first(name: "X-GitHub-Event"),
              let e = GitHubEvent(rawValue: event) else {
                  throw Abort(.badRequest)
              }

        guard req.body.data != nil else {
            throw Abort(.badRequest, reason: "Body is empty.")
        }

        // Check if secret protected Server
        if let secret = Environment.get(Environment.secret.name) {
            guard let signature = req.headers.first(name: "X-Hub-Signature-256"),
                  let bodyData = req.body.data,
                  verifySignature(signature, for: Data(buffer: bodyData), secret: secret) else {
                      let error = Abort(.badRequest, reason: "Signature is not match for secret.")
                      req.application.logger.error(Logger.Message(stringLiteral: error.description))
                      throw error
                  }
        }
        
        switch e {
        case .ping:
            return try GitHubHandler.handlePing(req)

        case .pull_request:
            return try GitHubHandler.handlePullRequest(req)

        case .pull_request_review:
            return try GitHubHandler.handlePullRequestReview(req)

        case .pull_request_review_comment:
            return try GitHubHandler.handlePullRequestReviewComment(req)

        case .workflow_job:
            return try GitHubHandler.handleWorkflowJob(req)

        case .workflow_run:
            return try GitHubHandler.handleWorkflowRun(req)

        default:
            throw Abort(.notImplemented)
        }
    }
}

extension GitHubHandler {

    static func handlePing(_ req: Request) throws -> String {
        guard let jsonObject = try req.getBodyJsonObject(),
              let zen = jsonObject["zen"] as? String,
              let repository = jsonObject["repository"] as? [String: Any],
              let name = repository["full_name"] as? String,
              let url = repository["html_url"] as? String else {
                  throw Abort(.badRequest)
              }

        var markdown = """
        # [\(name)](\(url))
        zen: \(zen)
        """

        if let description = jsonObject["description"] as? String {
            markdown += "description: \(description)"
        }

        return markdown
    }
}

extension GitHubHandler {

    static func handlePullRequest(_ req: Request) throws -> String {
        guard let jsonObject = try req.getBodyJsonObject(),
              let action = jsonObject["action"] as? String,
              let act = GitHubAction(rawValue: action),
              let pr = jsonObject["pull_request"] as? [String: Any],
              let number = pr["number"] as? Int,
              let url = pr["html_url"] as? String,
              let repository = (jsonObject["repository"] as? [String: Any])?["full_name"] as? String else {
                  throw Abort(.badRequest)
              }

        guard var state = pr["state"] as? String,
              let draft = pr["draft"] as? Bool,
              let merged = pr["merged"] as? Bool,
              let title = pr["title"] as? String,
              let user = (pr["user"] as? [String: Any])?["login"] as? String,
              let head = pr["head"] as? [String: Any],
              let headRef = head["ref"] as? String,
              let base = pr["base"] as? [String: Any],
              let baseRef = base["ref"] as? String else {
                  throw Abort(.badRequest)
              }

        if draft {
            return "Ignored draft, action: \(act.rawValue), number: \(number)"
        }

        let _ = pr["body"] as? String
        let mergedBy = (pr["merged_by"] as? [String: Any])?["login"] as? String

        if state.elementsEqual("closed"), merged {
            state = "merged"
        }

        var markdown = """
        # \(repository)
        Pull request: `\(state)` [\(title)(#\(number))](\(url))
        \(baseRef) ← \(headRef)
        user: \(user)
        """

        if act == .review_requested, let reviewers = pr["requested_reviewers"] as? [[String: Any]] {
            var names = String()

            for reviewer in reviewers {
                if let name = reviewer["login"] as? String {
                    names += "\(name), "
                }
            }

            names.removeLast(2) // remove ", " at last

            markdown += "\nreviewer: \(names)"
        } else if (act == .labeled || act == .unlabeled),
                    let label = jsonObject["label"] as? [String: Any], let name = label["name"] as? String {
            markdown += " \(name)"
        }

        if merged, let mergedBy = mergedBy {
            markdown += "\n`\(action)` by \(mergedBy)"
        } else {
            markdown += " `\(action)`"
        }

        return markdown
    }

    static func handlePullRequestReview(_ req: Request) throws -> String {
        guard let jsonObject = try req.getBodyJsonObject(),
              let action = jsonObject["action"] as? String,
              let _ = GitHubAction(rawValue: action),
              let review = jsonObject["review"] as? [String: Any],
              let pr = jsonObject["pull_request"] as? [String: Any],
              let number = pr["number"] as? Int,
              let url = pr["html_url"] as? String,
              let title = pr["title"] as? String,
              let repository = (jsonObject["repository"] as? [String: Any])?["full_name"] as? String else {
                  throw Abort(.badRequest)
              }

        guard let head = pr["head"] as? [String: Any],
              let headRef = head["ref"] as? String,
              let base = pr["base"] as? [String: Any],
              let baseRef = base["ref"] as? String else {
                  throw Abort(.badRequest)
              }

        guard let state = review["state"] as? String,
              let user = (review["user"] as? [String: Any])?["login"] as? String else {
                  throw Abort(.badRequest)
              }

        let markdown = """
        # \(repository)
        Review: `\(state)` [\(title)(#\(number))](\(url))
        \(baseRef) ← \(headRef)
        user: \(user) `\(action)`
        """

        return markdown
    }

    static func handlePullRequestReviewComment(_ req: Request) throws -> String {
        guard let jsonObject = try req.getBodyJsonObject(),
              let action = jsonObject["action"] as? String,
              let comment = jsonObject["comment"] as? [String: Any],
              let pr = jsonObject["pull_request"] as? [String: Any],
              let number = pr["number"] as? Int,
              let url = pr["html_url"] as? String,
              let title = pr["title"] as? String,
              let repository = (jsonObject["repository"] as? [String: Any])?["full_name"] as? String else {
                  throw Abort(.badRequest)
              }

        guard let head = pr["head"] as? [String: Any],
              let headRef = head["ref"] as? String,
              let base = pr["base"] as? [String: Any],
              let baseRef = base["ref"] as? String else {
                  throw Abort(.badRequest)
              }

        guard let user = (comment["user"] as? [String: Any])?["login"] as? String,
              let _ = comment["body"] else {
                  throw Abort(.badRequest)
              }

        let markdown = """
        # \(repository)
        Review comment: [\(title)(#\(number))](\(url))
        \(baseRef) ← \(headRef)
        user: \(user) `\(action)`
        """

        return markdown
    }
}

extension GitHubHandler {

    static func handleWorkflowJob(_ req: Request) throws -> String {
        guard let jsonObject = try req.getBodyJsonObject(),
              let action = jsonObject["action"] as? String,
              let _ = GitHubAction(rawValue: action),
              let repository = (jsonObject["repository"] as? [String: Any])?["full_name"] as? String else {
                  throw Abort(.badRequest)
              }

        guard let job = jsonObject["workflow_job"] as? [String: Any],
              let jobName = job["name"] as? String,
              let status = job["status"] as? String,
              let url = job["html_url"] as? String else {
                  throw Abort(.badRequest)
              }

        let conclusion = job["conclusion"] as? String

        var markdown = """
        # \(repository)
        Workflow job `\(conclusion ?? status)`: [\(jobName)](\(url))
        status: `\(status)`
        """

        if let steps = job["steps"] as? [[String: Any]], !steps.isEmpty {
            markdown += "\nsteps:\n"

            for step in steps {
                let status = step["status"] as? String
                let conclusion = step["conclusion"] as? String
                markdown += "`\(conclusion ?? status!)`: \(step["name"] as! String)\n"
            }

            markdown.removeLast(1) // remove "\n" at last
        }

        return markdown
    }

    static func handleWorkflowRun(_ req: Request) throws -> String {
        guard let jsonObject = try req.getBodyJsonObject(),
              let action = jsonObject["action"] as? String,
              let _ = GitHubAction(rawValue: action),
              let repository = (jsonObject["repository"] as? [String: Any])?["full_name"] as? String else {
                  throw Abort(.badRequest)
              }

        guard let run = jsonObject["workflow_run"] as? [String: Any],
              let runName = run["name"] as? String,
              let status = run["status"] as? String,
              let url = run["html_url"] as? String else {
                  throw Abort(.badRequest)
              }

        let conclusion = run["conclusion"] as? String

        let markdown = """
        # \(repository)
        Workflow run `\(conclusion ?? status)`: [\(runName)](\(url))
        status: `\(status)`
        """

        return markdown
    }
}
