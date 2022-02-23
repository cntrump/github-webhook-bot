//
//  Bot.swift
//  
//
//  Created by lvv.me on 2022/2/19.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
import Vapor

class WeWorkBot {

    var key: String

    var url = "https://qyapi.weixin.qq.com/cgi-bin/webhook/send"

    let markdown: String

    var body: Data? {
        try? JSONSerialization.data(withJSONObject: [
            "msgtype": "markdown",
            "markdown": [
                "content": markdown
            ]
        ], options: [])
    }

    init(key: String, markdown: String) {
        self.key = key
        self.markdown = markdown
    }

    func send() throws -> String {
        guard let url = URL(string: url + "?key=\(key)") else {
            throw Abort(.badRequest, reason: "Invalid URL: \(url)?key=\(key)")
        }

        guard let body = body else {
            throw Abort(.badRequest, reason: "Invalid Body: \(markdown)")
        }

        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.addValue("application/json", forHTTPHeaderField: "Content-Type")
        req.addValue("\(body.count)", forHTTPHeaderField: "Content-Length")
        req.httpBody = body
        let task = URLSession.shared.dataTask(with: req) { data, resp, error in
        }

        task.resume()

        //
        // GitHub expects that integrations respond within 10 seconds of receiving the webhook payload.
        // If your service takes longer than that to complete, then GitHub terminates the connection and the payload is lost.
        //
        // https://docs.github.com/en/rest/guides/best-practices-for-integrators#favor-asynchronous-work-over-synchronous
        //

        return """
               {
                 "status": "success",
                 "message": "Sending to WeWork bot."
               }
               """
    }
}
