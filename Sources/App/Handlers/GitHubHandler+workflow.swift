//
//  GitHubHandler+workflow.swift
//  
//
//  Created by lvv.me on 2022/2/23.
//

import Vapor

extension GitHubHandler {

    static func handleCheckSuite(_ req: Request) throws -> String {
        let payload = try req.content.decode(GHCheckSuitePayload.self)
        let suite = payload.checkSuite
        let repo = payload.repository

        let markdown = """
        # \(repo.fullName)
        Check suite `\(suite.conclusion ?? suite.status)`: \(suite.headBranch)
        status: `\(suite.status)`
        """

        return markdown
    }

    static func handleCheckRun(_ req: Request) throws -> String {
        let payload = try req.content.decode(GHCheckRunPayload.self)
        let run = payload.checkRun
        let suite = run.checkSuite
        let repo = payload.repository

        let markdown = """
        # \(repo.fullName)
        Check run `\(run.conclusion ?? run.status)`: [\(run.name)](\(run.htmlUrl))
        branch: \(suite.headBranch)
        status: `\(run.status)`
        """

        return markdown
    }

    static func handleWorkflowJob(_ req: Request) throws -> String {
        let payload = try req.content.decode(GHWorkflowJobPayload.self)
        let job = payload.workflowJob
        let repo = payload.repository

        var markdown = """
        # \(repo.fullName)
        Workflow job `\(job.conclusion ?? job.status)`: [\(job.name)](\(job.htmlUrl))
        status: `\(job.status)`
        """

        if let steps = job.steps, !steps.isEmpty {
            markdown += "\nsteps:\n"

            for step in steps {
                let status = step.status
                let conclusion = step.conclusion
                markdown += "`\(conclusion ?? status)`: \(step.name)\n"
            }

            markdown.removeLast(1) // remove "\n" at last
        }

        return markdown
    }

    static func handleWorkflowRun(_ req: Request) throws -> String {
        let payload = try req.content.decode(GHWorkflowRunPayload.self)
        let run = payload.workflowRun
        let repo = payload.repository

        let markdown = """
        # \(repo.fullName)
        Workflow run `\(run.conclusion ?? run.status)`: [\(run.name)](\(run.htmlUrl))
        status: `\(run.status)`
        """

        return markdown
    }
}
