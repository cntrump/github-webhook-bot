//
//  GHCheckSuitePayload.swift
//  
//
//  Created by lvv.me on 2022/2/23.
//

import Foundation

struct GHCheckSuitePayload: Decodable {
    var action: String
    var checkSuite: GHCheckSuite
    var repository: GHRepository
    var sender: GHUser
}
