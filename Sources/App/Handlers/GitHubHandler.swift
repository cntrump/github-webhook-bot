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

        case .release:
            return try GitHubHandler.handleRelease(req)

        case .push:
            return try GitHubHandler.handlePush(req)

        case .create:
            return try GitHubHandler.handleCreate(req)

        case .delete:
            return try GitHubHandler.handleDelete(req)

        case .pull_request:
            return try GitHubHandler.handlePullRequest(req)

        case .pull_request_review:
            return try GitHubHandler.handlePullRequestReview(req)

        case .pull_request_review_comment:
            return try GitHubHandler.handlePullRequestReviewComment(req)

        case .pull_request_review_thread:
            return try GitHubHandler.handlePullRequestReviewThread(req)

        case .check_suite:
            return try GitHubHandler.handleCheckSuite(req)

        case .check_run:
            return try GitHubHandler.handleCheckRun(req)

        case .workflow_job:
            return try GitHubHandler.handleWorkflowJob(req)

        case .workflow_run:
            return try GitHubHandler.handleWorkflowRun(req)

        case .issues:
            return try GitHubHandler.handleIssues(req)

        case .issue_comment:
            return try GitHubHandler.handleIssueComment(req)

        default:
            throw Abort(.notImplemented, reason: "Not implemented Event: \(e.rawValue)")
        }
    }
}
