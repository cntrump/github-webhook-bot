//
//  GitHubHandler+issue.swift
//  
//
//  Created by lvv.me on 2022/2/23.
//

import Vapor

extension GitHubHandler {

    static func handleIssues(_ req: Request) throws -> String {
        let payload = try req.content.decode(GHIssuePayload.self)
        let action = payload.action
        let issue = payload.issue
        let repo = payload.repository

        let markdown = """
        # \(repo.fullName)
        Issue `\(action)`: [\(issue.title)(#\(issue.number))](\(issue.htmlUrl))
        user: \(issue.user.login)
        """

        return markdown
    }

    static func handleIssueComment(_ req: Request) throws -> String {
        let payload = try req.content.decode(GHIssueCommentPayload.self)
        let action = payload.action
        let issue = payload.issue
        let comment = payload.comment
        let repo = payload.repository

        let pr = issue.pullRequest

        let markdown = """
        # \(repo.fullName)
        \(pr != nil ? "Pull request" : "Issue" ) comment `\(action)`: [\(issue.title)(#\(issue.number))](\(comment.htmlUrl))
        user: \(comment.user.login)
        """

        return markdown
    }
}
