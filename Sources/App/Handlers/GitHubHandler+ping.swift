//
//  GitHubHandler+ping.swift
//  
//
//  Created by lvv.me on 2022/2/23.
//

import Vapor

extension GitHubHandler {

    static func handlePing(_ req: Request) throws -> String {
        let payload = try req.content.decode(GHPingPayload.self)
        let repo = payload.repository

        var markdown = """
        # \(repo.fullName)
        zen: \(payload.zen)
        """

        if let description = repo.description {
            markdown += "\ndescription: \(description)"
        }

        return markdown
    }
}
