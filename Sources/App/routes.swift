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
        guard let event = req.headers.first(name: "X-GitHub-Event"), let e = GitHubEvent(rawValue: event) else {
            throw Abort(.badRequest)
        }

        // Check if secret protected Server
        if let secret = Environment.get(Environment.secret.name)  {
            guard let signature = req.headers.first(name: "X-Hub-Signature-256"),
                  let bodyData = req.body.data,
                  GitHubHandler.verifySignature(signature, for: Data(buffer: bodyData), secret: secret) else {
                      throw Abort(.badRequest)
                  }
        }

        guard let botId = req.query[String.self, at: "id"] else {
            throw Abort(.badRequest)
        }

        let markdown: String!

        switch e {
        case .ping:
            markdown = try GitHubHandler.handlePing(req)

        case .pull_request:
            markdown = try GitHubHandler.handlePullRequest(req)

        case .pull_request_review:
            markdown = try GitHubHandler.handlePullRequestReview(req)

        case .pull_request_review_comment:
            markdown = try GitHubHandler.handlePullRequestReviewComment(req)

        case .workflow_job:
            markdown = try GitHubHandler.handleWorkflowJob(req)

        case .workflow_run:
            markdown = try GitHubHandler.handleWorkflowRun(req)

        default:
            throw Abort(.notImplemented)
        }

        let bot = WeWorkBot(key: botId, markdown: markdown, logger: req.logger)

        return try await bot.send()
    }
}
