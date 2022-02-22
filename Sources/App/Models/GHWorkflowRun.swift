//
//  GHWorkflowRun.swift
//  
//
//  Created by lvv.me on 2022/2/22.
//

import Foundation

struct GHWorkflowRun: Decodable {
    var name: String
    var htmlUrl: String
    var status: String
    var conclusion: String?
}
