//
//  GHCheckRunPayload.swift
//  
//
//  Created by lvv.me on 2022/2/25.
//

import Foundation

struct GHCheckRunPayload: Decodable {
    var action: String
    var checkRun: GHCheckRun
    var repository: GHRepository
    var sender: GHUser
}
