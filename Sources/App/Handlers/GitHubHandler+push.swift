//
//  GitHubHandler+push.swift
//  
//
//  Created by lvv.me on 2022/2/23.
//

import Vapor

extension GitHubHandler {

    static func handlePush(_ req: Request) throws -> String {
        let payload = try req.content.decode(GHPushPayload.self)
        let repo = payload.repository

        var markdown = """
        # [\(repo.fullName)](\(repo.htmlUrl))
        Push: [\(payload.ref)](\(payload.compare))
        user: \(payload.pusher.name)
        """

        if let commits = payload.commits, !commits.isEmpty {
            markdown += "\n\(commits.count) commits"
        }

        return markdown
    }
}

