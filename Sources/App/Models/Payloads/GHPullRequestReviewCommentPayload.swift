//
//  PullRequestReviewCommentPayload.swift
//  
//
//  Created by lvv.me on 2022/2/22.
//

import Foundation

struct PullRequestReviewCommentPayload: Decodable {
    var action: GitHubAction
    var comment: GHComment
    var pullRequest: GHPullRequest
    var repository: GHRepository
    var sender: GHUser
}
