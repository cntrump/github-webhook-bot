import Vapor

func routes(_ app: Application) throws {
    app.get { req in
        return "It works!"
    }

    app.get("hello") { req -> String in
        return "Hello, world!"
    }

    /// route /github/wework?id=
    app.post("github", "wework") { req async throws -> String in
        guard let botId = req.query[String.self, at: "id"] else {
            throw Abort(.badRequest)
        }

        let markdown = try GitHubHandler.handleEvents(req)
        let bot = WeWorkBot(key: botId, markdown: markdown, logger: req.logger)

        return try await bot.send()
    }
}
