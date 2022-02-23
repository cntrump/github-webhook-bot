//
//  GHIssuePayload.swift
//  
//
//  Created by lvv.me on 2022/2/23.
//

import Foundation

struct GHIssuePayload: Decodable {
    var action: GitHubAction
    var issue: GHIssue
    var repository: GHRepository
    var sender: GHUser
}
