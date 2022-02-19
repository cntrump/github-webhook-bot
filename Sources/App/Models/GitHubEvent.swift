//
//  GitHubEvent.swift
//  
//
//  Created by lvv.me on 2022/2/18.
//

import Foundation

enum GitHubEvent: String {

    case branch_protection_rule

    case check_run

    case check_suite

    case code_scanning_alert

    case commit_comment

    case create

    case delete

    case deploy_key

    case deployment

    case deployment_status

    case discussion

    case discussion_comment

    case fork

    case github_app_authorization

    case gollum

    case installation

    case installation_repositories

    case issue_comment

    case issues

    case label

    case marketplace_purchase

    case member

    case membership

    case meta

    case milestone

    case organization

    case org_block

    case package

    case page_build

    case ping

    case project

    case project_card

    case project_column

    case `public`

    case pull_request

    case pull_request_review

    case pull_request_review_comment

    case push

    case release

    case repository_dispatch

    case repository

    case repository_import

    case repository_vulnerability_alert

    case secret_scanning_alert

    case security_advisory

    case sponsorship

    case star

    case status

    case team

    case team_add

    case watch

    case workflow_dispatch

    case workflow_job

    case workflow_run
}
