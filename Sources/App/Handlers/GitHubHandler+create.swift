//
//  GitHubHandler+create.swift
//  
//
//  Created by lvv.me on 2022/2/25.
//

import Vapor

extension GitHubHandler {

    static func handleCreate(_ req: Request) throws -> String {
        let payload = try req.content.decode(GHCreatePayload.self)
        let repo = payload.repository

        let markdown = """
        # [\(repo.fullName)](\(repo.htmlUrl))
        Created new \(payload.refType): \(payload.ref)
        from: \(payload.masterBranch)
        user: \(payload.sender.login)
        """

        return markdown
    }
}

