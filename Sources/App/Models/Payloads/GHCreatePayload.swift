//
//  GHCreatePayload.swift
//  
//
//  Created by lvv.me on 2022/2/25.
//

import Foundation

struct GHCreatePayload: Decodable {
    var ref: String
    var refType: String
    var masterBranch: String
    var description: String?
    var repository: GHRepository
    var sender: GHUser
}
