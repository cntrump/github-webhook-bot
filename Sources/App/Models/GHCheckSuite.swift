//
//  GHCheckSuite.swift
//  
//
//  Created by lvv.me on 2022/2/23.
//

import Foundation

struct GHCheckSuite: Decodable {
    var headBranch: String
    var status: String
    var conclusion: String?
}
