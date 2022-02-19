//
//  GitHubRepository.swift
//  
//
//  Created by lvv.me on 2022/2/18.
//

import Foundation
import Vapor

struct GitHubRepositoryLicense: Decodable {
    var key: String
    var name: String
    var spdxId: String
    var url: URL
    var nodeId: String
}

enum GitHubGitHubRepositoryVisibility: String, Decodable {
    case `public`
    case `private`
}

struct GitHubRepository: Decodable {
    var id: Int
    var nodeId: String
    var name: String
    var fullName: String
    var `private`: Bool
    var owner: GitHubUser
    var htmlUrl: URL
    var description: String?
    var fork: Bool
    var url: URL
    var forksUrl: URL
    var keysUrl: URL
    var collaboratorsUrl: URL
    var teamsUrl: URL
    var hooksUrl: URL
    var issueEventsUrl: URL
    var eventsUrl: URL
    var assigneesUrl: URL
    var branchesUrl: URL
    var tagsUrl: URL
    var blobsUrl: URL
    var gitTagsUrl: URL
    var gitRefsUrl: URL
    var treesUrl: URL
    var statusesUrl: URL
    var languagesUrl: URL
    var stargazersUrl: URL
    var contributorsUrl: URL
    var subscribersUrl: URL
    var subscriptionUrl: URL
    var commitsUrl: URL
    var gitCommitsUrl: URL
    var commentsUrl: URL
    var issueCommentUrl: URL
    var contentsUrl: URL
    var compareUrl: URL
    var mergesUrl: URL
    var archiveUrl: URL
    var downloadsUrl: URL
    var issuesUrl: URL
    var pullsUrl: URL
    var milestonesUrl: URL
    var notificationsUrl: URL
    var labelsUrl: URL
    var releasesUrl: URL
    var deploymentsUrl: URL
    var createdAt: Date
    var updatedAt: Date
    var pushedAt: Date
    var gitUrl: String
    var sshUrl: String
    var cloneUrl: URL
    var svnUrl: URL
    var homepage: URL?
    var size: Int
    var stargazersCount: Int
    var watchersCount: Int
    var language: String?
    var hasIssues: Bool
    var hasProjects: Bool
    var hasDownloads: Bool
    var hasWiki: Bool
    var hasPages: Bool
    var forksCount: Int
    var mirrorUrl: URL?
    var archived: Bool
    var disabled: Bool
    var openIssuesCount: Int
    var license: GitHubRepositoryLicense?
    var allowForking: Bool
    var isTemplate: Bool
    var topics: [ String ]?
    var visibility: GitHubGitHubRepositoryVisibility
    var forks: Int
    var openIssues: Int
    var watchers: Int
    var defaultBranch: String
    var allowSquashMerge: Bool
    var allowMergeCommit: Bool
    var allowRebaseMerge: Bool
    var allowAutoMerge: Bool
    var deleteBranchOnMerge: Bool
    var allowUpdateBranch: Bool
}
