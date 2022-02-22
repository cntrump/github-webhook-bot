//
//  GHPullRequest.swift
//  
//
//  Created by lvv.me on 2022/2/22.
//

import Foundation

struct GHPullRequest: Decodable {
    var htmlUrl: String
    var number: Int
    var state: String
    var title: String
    var user: GHUser
    var body: String?
    var requestedReviewers: [GHUser]?
    var labels: [GHLabel]?
    var head: GHOrigin
    var base: GHOrigin
    var draft: Bool
    var merged: Bool?
    var mergedBy: GHUser?
}
