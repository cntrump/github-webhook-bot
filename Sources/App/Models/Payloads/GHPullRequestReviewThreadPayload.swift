//
//  GHPullRequestReviewThreadPayload.swift
//  
//
//  Created by lvv.me on 2022/2/23.
//

import Foundation

struct GHPullRequestReviewThreadPayload: Decodable {
    var action: GitHubAction
    var pullRequest: GHPullRequest
    var repository: GHRepository
    var sender: GHUser
}
