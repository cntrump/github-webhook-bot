//
//  GHRelease.swift
//  
//
//  Created by lvv.me on 2022/3/10.
//

import Foundation

struct GHRelease: Decodable {
    var htmlUrl: String
    var tagName: String
    var targetCommitish: String
    var name: String?
    var draft: Bool
    var author: GHUser
    var prerelease: Bool
    var body: String?
}
