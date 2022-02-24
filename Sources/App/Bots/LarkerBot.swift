//
//  LarkerBot.swift
//  
//
//  Created by lvv.me on 2022/2/23.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
import Vapor
import Crypto

class LarkerBot {

    var id: String

    var url = "https://open.larksuite.com/open-apis/bot/v2/hook/"

    var secret: String?

    let timestamp = Int(Date().timeIntervalSince1970)

    var signature: String? {
        guard let secret = secret else {
            return nil
        }

        let token = "\(timestamp)\n\(secret)"

        guard let tokenData = token.data(using: .utf8) else {
            return nil
        }

        let key = SymmetricKey(data: tokenData)
        let signature = Data(HMAC<SHA256>.authenticationCode(for: Data(), using: key))

        return signature.base64EncodedString(options: .lineLength64Characters)
    }

    var markdown: String

    var body: Data? {
        var json = [String: Any]()
        json["timestamp"] = "\(timestamp)"
        json["msg_type"] = "text"
        json["content"] = [ "text": markdown ]

        if secret != nil {
            json["sign"] = signature
        }

        return try? JSONSerialization.data(withJSONObject: json, options: [])
    }
    
    init(id: String, markdown: String, secret: String? = nil) {
        self.id = id
        self.secret = secret
        self.markdown = markdown
    }

    func send() throws -> String {
        guard let url = URL(string: url + id) else {
            throw Abort(.badRequest, reason: "Invalid URL: \(url)\(id)")
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
                 "message": "Sending to Larker bot."
               }
               """
    }
}
