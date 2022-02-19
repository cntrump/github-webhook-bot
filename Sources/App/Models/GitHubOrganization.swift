//
//  GitHubOrganization.swift
//  
//
//  Created by lvv.me on 2022/2/18.
//

import Foundation

struct GitHubOrganization: Decodable {
    var login: String
    var id: Int
    var nodeId: String
    var url: URL
    var reposUrl: URL
    var eventsUrl: URL
    var hooksUrl: URL
    var issuesUrl: URL
    var membersUrl: URL
    var publicMembersUrl: URL
    var avatarUrl: URL
    var description: String?
}
