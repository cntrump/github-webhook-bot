//
//  GHPushPayload.swift
//  
//
//  Created by lvv.me on 2022/2/23.
//

import Foundation

struct GHPushPayload: Decodable {
    var ref: String
    var pusher: GHPusher
    var commits: [GHCommit]?
    var headCommit: GHCommit?
    var compare: String
    var repository: GHRepository
    var sender: GHUser
}

struct GHPusher: Decodable {
    var name: String
    var email: String
}
