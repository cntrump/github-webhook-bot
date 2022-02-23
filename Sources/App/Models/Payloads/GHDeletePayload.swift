//
//  GHDeletePayload.swift
//  
//
//  Created by lvv.me on 2022/2/23.
//

import Foundation

struct GHDeletePayload: Decodable {
    var ref: String
    var refType: String
    var repository: GHRepository
    var sender: GHUser
}
