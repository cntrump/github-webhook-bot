//
//  GitHubUser.swift
//  
//
//  Created by lvv.me on 2022/2/18.
//

import Foundation

enum GitHubUserType: String, Decodable {
    case User
    case Organization
}

struct GitHubUser: Decodable {
    var login: String
    var id: Int
    var nodeId: String
    var avatarUrl: String
    var gravatarId: String
    var url: URL
    var htmlUrl: URL
    var followersUrl: URL
    var followingUrl: URL
    var gistsUrl: URL
    var starredUrl: URL
    var subscriptionsUrl: URL
    var organizationsUrl: URL
    var reposUrl: URL
    var eventsUrl: URL
    var receivedEventsUrl: URL
    var type: GitHubUserType
    var siteAdmin: Bool
}
