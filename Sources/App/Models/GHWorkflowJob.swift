//
//  GHWorkflowJob.swift
//  
//
//  Created by lvv.me on 2022/2/22.
//

import Foundation

struct GHWorkflowJob: Decodable {
    var htmlUrl: String
    var status: String
    var conclusion: String?
    var name: String
    var steps: [GHWorkflowJobStep]?
}
