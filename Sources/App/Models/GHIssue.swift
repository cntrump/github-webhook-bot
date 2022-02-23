//
//  GHIssue.swift
//  
//
//  Created by lvv.me on 2022/2/23.
//

import Foundation

struct GHIssue: Decodable {
    var number: Int
    var htmlUrl: String
    var title: String
    var user: GHUser
    var state: String
    var body: String?
    var pullRequest: GHIssuePullRequest?
}

struct GHIssuePullRequest: Decodable {
    var htmlUrl: String
}
