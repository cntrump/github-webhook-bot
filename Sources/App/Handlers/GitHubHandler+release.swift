//
//  GitHubHandler+release.swift
//  
//
//  Created by lvv.me on 2022/2/25.
//

import Vapor

extension GitHubHandler {

    static func handleRelease(_ req: Request) throws -> String {
        let payload = try req.content.decode(GHReleasePayload.self)
        let action = payload.action
        let release = payload.release
        let repo = payload.repository

        let markdown = """
        # \(repo.fullName)
        Release `\(action)`: \(release.tagName)
        from: \(release.targetCommitish)
        user: \(release.author.login)
        """

        return markdown
    }
}

