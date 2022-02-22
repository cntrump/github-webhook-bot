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
import Logging

protocol Bot {

    var request: URLRequest { get }

    var body: Data { get }

    func send() async throws -> String
}

class WeWorkBot: Bot {
    var logger: Logger?

    var url: URL?
    let markdown: String

    var request: URLRequest {
        URLRequest(url: url!)
    }

    var body: Data {
        (try? JSONSerialization.data(withJSONObject: [
            "msgtype": "markdown",
            "markdown": [
                "content": markdown
            ]
        ], options: [])) ?? Data()
    }

    init(key: String, markdown: String, logger: Logger? = nil) {
        self.markdown = markdown
        self.logger = logger
        var uc = URLComponents(string: "https://qyapi.weixin.qq.com/cgi-bin/webhook/send")
        uc?.queryItems = [ URLQueryItem(name: "key", value: key) ]
        url = uc?.url
    }

    func send() throws -> String {
        var req = request
        req.httpMethod = "POST"
        req.addValue("application/json", forHTTPHeaderField: "Content-Type")
        req.addValue("\(body.count)", forHTTPHeaderField: "Content-Length")
        req.httpBody = body
        
        let task = URLSession.shared.dataTask(with: req) { data, resp, error in
            if let error = error {
                self.logger?.error("\(error)")
            }
        }

        task.resume()

        return """
               {
                 "status": "success",
                 "message": "Sending to WeWork bot."
               }
               """

        //
        // GitHub expects that integrations respond within 10 seconds of receiving the webhook payload.
        // If your service takes longer than that to complete, then GitHub terminates the connection and the payload is lost.
        //
        // https://docs.github.com/en/rest/guides/best-practices-for-integrators#favor-asynchronous-work-over-synchronous
        //

//        let data = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Data, Error>) -> Void in
//            let task = URLSession.shared.dataTask(with: req) { data, resp, error in
//                if let error = error {
//                    continuation.resume(throwing: error)
//                    return
//                }
//
//                continuation.resume(returning: data ?? Data())
//            }
//
//            task.resume()
//        }
//
//        return String(data: data, encoding: .utf8) ?? "Ok"
    }
}
