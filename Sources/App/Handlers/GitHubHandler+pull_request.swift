//
//  GitHubHandler+pull_request.swift
//  
//
//  Created by lvv.me on 2022/2/23.
//

import Vapor

extension GitHubHandler {

    static func handlePullRequest(_ req: Request) throws -> String {
        let payload = try req.content.decode(GHPullRequestPayload.self)
        let action = payload.action
        let pr = payload.pullRequest

        var state = pr.state

        if pr.state.elementsEqual("closed"), let merged = pr.merged, merged {
            state = "merged"
        }

        var markdown = """
        # \(payload.repository.fullName)
        Pull request: `\(state)` [\(pr.title)(#\(pr.number))](\(pr.htmlUrl))
        \(pr.base.ref) ← \(pr.head.ref)
        user: \(pr.user.login)
        """

        if let merged = pr.merged, merged, let mergedBy = pr.mergedBy {
            markdown += "\n`\(action)` by \(mergedBy.login)"
        } else {
            markdown += " `\(action)`"
        }

        if action == .review_requested, let reviewers = pr.requestedReviewers {
            var names = String()

            for reviewer in reviewers {
                names += "\(reviewer.login), "
            }

            names.removeLast(2) // remove ", " at last

            markdown += "\nreviewer: \(names)"
        } else if (action == .labeled || action == .unlabeled),
                  let label = payload.label {
            markdown += " \(label.name)"
        }

        return markdown
    }

    static func handlePullRequestReview(_ req: Request) throws -> String {
        let payload = try req.content.decode(GHPullRequestReviewPayload.self)
        let action = payload.action
        let review = payload.review
        let pr = payload.pullRequest
        let repo = payload.repository

        let markdown = """
        # \(repo.fullName)
        Review: `\(review.state)` [\(pr.title)(#\(pr.number))](\(review.htmlUrl))
        \(pr.base.ref) ← \(pr.head.ref)
        user: \(review.user.login) `\(action)`
        """

        return markdown
    }

    static func handlePullRequestReviewComment(_ req: Request) throws -> String {
        let payload = try req.content.decode(PullRequestReviewCommentPayload.self)
        let action = payload.action
        let comment = payload.comment
        let pr = payload.pullRequest
        let repo = payload.repository

        let markdown = """
        # \(repo.fullName)
        Review comment `\(action)`: [\(pr.title)(#\(pr.number))](\(comment.htmlUrl))
        \(pr.base.ref) ← \(pr.head.ref)
        user: \(comment.user.login)
        """

        return markdown
    }

    static func handlePullRequestReviewThread(_ req: Request) throws -> String {
        let payload = try req.content.decode(GHPullRequestReviewThreadPayload.self)
        let action = payload.action
        let pr = payload.pullRequest
        let repo = payload.repository

        let markdown = """
        # \(repo.fullName)
        Review thread `\(action)`: [\(pr.title)(#\(pr.number))](\(pr.htmlUrl))
        \(pr.base.ref) ← \(pr.head.ref)
        user: \(pr.user.login)
        """

        return markdown
    }
}
