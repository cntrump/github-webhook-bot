//
//  GHPullRequestReviewPayload.swift
//  
//
//  Created by lvv.me on 2022/2/22.
//

import Foundation

struct GHPullRequestReviewPayload: Decodable {
    var action: GitHubAction
    var review: GHReview
    var pullRequest: GHPullRequest
    var repository: GHRepository
    var sender: GHUser
}
