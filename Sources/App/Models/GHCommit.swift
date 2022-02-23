//
//  GHCommit.swift
//  
//
//  Created by lvv.me on 2022/2/23.
//

import Foundation

struct GHCommit: Decodable {
    var id: String
    var message: String
    var url: String
    var author: GHCommitUser
    var committer: GHCommitUser
    var added: [String]?
    var removed: [String]?
    var modified: [String]?
}

struct GHCommitUser: Decodable {
    var name: String
    var email: String
    var username: String?
}
