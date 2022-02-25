//
//  GHCheckRun.swift
//  
//
//  Created by lvv.me on 2022/2/25.
//

import Foundation

struct GHCheckRun: Decodable {
    var name: String
    var htmlUrl: String
    var status: String
    var conclusion: String?
    var checkSuite: GHCheckSuite
}
