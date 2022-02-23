//
//  GHWorkflowJobStep.swift
//  
//
//  Created by lvv.me on 2022/2/22.
//

import Foundation

struct GHWorkflowJobStep: Decodable {
    var number: Int
    var name: String
    var status: String
    var conclusion: String?
}
