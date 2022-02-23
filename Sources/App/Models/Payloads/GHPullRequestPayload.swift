//
//  GHPullRequestPayload.swift
//  
//
//  Created by lvv.me on 2022/2/22.
//

import Foundation

struct GHPullRequestPayload: Decodable {
    var action: GitHubAction
    var number: Int
    var pullRequest: GHPullRequest
    var body: String?
    var label: GHLabel?
    var repository: GHRepository
    var sender: GHUser
}
