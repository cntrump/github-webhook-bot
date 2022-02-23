//
//  GHWorkflowJobPayload.swift
//  
//
//  Created by lvv.me on 2022/2/22.
//

import Foundation

struct GHWorkflowJobPayload: Decodable {
    var action: GitHubAction
    var workflowJob: GHWorkflowJob
    var repository: GHRepository
    var sender: GHUser
}
