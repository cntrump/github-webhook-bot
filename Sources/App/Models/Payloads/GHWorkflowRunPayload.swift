//
//  GHWorkflowRunPayload.swift
//  
//
//  Created by lvv.me on 2022/2/22.
//

import Foundation

struct GHWorkflowRunPayload: Decodable {
    var action: GitHubAction
    var workflowRun: GHWorkflowRun
    var repository: GHRepository
    var sender: GHUser
}
