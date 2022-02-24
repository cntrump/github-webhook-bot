//
//  ResponseMiddleware.swift
//  
//
//  Created by lvv.me on 2022/2/24.
//

import Vapor

struct ResponseMiddleware: Middleware {
    
    func respond(to request: Request, chainingTo next: Responder) -> EventLoopFuture<Response> {
            return next.respond(to: request).map {
                $0.headers.add(name: "X-Server-Version", value: version)
                return $0
            }
        }
}
