//
//  GitHubHandler+delete.swift
//  
//
//  Created by lvv.me on 2022/2/23.
//

import Vapor

extension GitHubHandler {

    static func handleDelete(_ req: Request) throws -> String {
        let payload = try req.content.decode(GHDeletePayload.self)
        let repo = payload.repository

        let markdown = """
        # [\(repo.fullName)](\(repo.htmlUrl))
        Delete `\(payload.refType)`: \(payload.ref)
        user: \(payload.sender.login)
        """

        return markdown
    }
}