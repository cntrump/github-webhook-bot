//
//  GitHubComment.swift
//  
//
//  Created by lvv.me on 2022/2/18.
//

import Foundation

struct GitHubComment: Decodable {
    var url: URL
    var htmlUrl: URL
    var id: Int
    var nodeId: String
    var user: GitHubUser
    var position: Int?
    var line: Int?
    var path: String
    var commitId: String
    var createdAt: Date
    var updatedAt: Date
    var authorAssociation: String
    var body: String
}
