import Vapor

func routes(_ app: Application) throws {
    app.get { req in
        return "It works!"
    }

    app.get("hello") { req -> String in
        return "Hello, world!"
    }

    /// route /github/wework?id=
    app.post("github", "wework") { req throws -> String in
        guard let botId = req.query[String.self, at: "id"] else {
            throw Abort(.badRequest)
        }

        let markdown = try GitHubHandler.handleEvents(req)
        let bot = WeWorkBot(key: botId, markdown: markdown)

        return try bot.send()
    }

    /// route /github/larker?id=
    app.post("github", "larker") { req throws -> String in
        guard let botId = req.query[String.self, at: "id"] else {
            throw Abort(.badRequest)
        }

        let secret = req.query[String.self, at: "secret"]

        let markdown = try GitHubHandler.handleEvents(req)
        let bot = LarkerBot(id: botId, markdown: markdown, secret: secret)

        return try bot.send()
    }

    /// route /github/dingtalk?id=
    app.post("github", "dingtalk") { req throws -> String in
        guard let botId = req.query[String.self, at: "id"] else {
            throw Abort(.badRequest)
        }

        let secret = req.query[String.self, at: "secret"]

        let markdown = try GitHubHandler.handleEvents(req)
        let bot = DingTalkBot(token: botId, markdown: markdown, secret: secret)

        return try bot.send()
    }
}
