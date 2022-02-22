//
//  GHIssueCommentPayload.swift
//  
//
//  Created by lvv.me on 2022/2/23.
//

import Foundation

struct GHIssueCommentPayload: Decodable {
    var action: GitHubAction
    var issue: GHIssue
    var comment: GHComment
    var repository: GHRepository
    var sender: GHUser
}
