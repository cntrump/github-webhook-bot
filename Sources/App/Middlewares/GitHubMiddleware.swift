//
//  GitHubMiddleware.swift
//  
//
//  Created by lvv.me on 2022/2/21.
//

import Vapor

struct GitHubMiddleware: Middleware {

    func respond(to request: Request, chainingTo next: Responder) -> EventLoopFuture<Response> {
        guard request.method == .POST, request.url.path.hasPrefix("github/") || request.url.path.hasPrefix("/github/") else {
            return next.respond(to: request)
        }

        guard let event = request.headers.first(name: "X-GitHub-Event"),
              GitHubEvent(rawValue: event) != nil else {
                  let error = Abort(.badRequest, reason: "Event not found.")
                  request.application.logger.error(Logger.Message(stringLiteral: error.description))
                  return request.eventLoop.makeFailedFuture(error)
              }

        // body may be nil in middleware: https://github.com/vapor/vapor/issues/2735
        // Check if secret protected Server
        if Environment.get(Environment.secret.name) != nil {
            guard request.headers.first(name: "X-Hub-Signature-256") != nil else {
                let error = Abort(.badRequest, reason: "X-Hub-Signature-256 not found in header.")
                request.application.logger.error(Logger.Message(stringLiteral: error.description))
                return request.eventLoop.makeFailedFuture(error)
            }
        }

        return next.respond(to: request)
    }
}
