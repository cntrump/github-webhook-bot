//
//  GHPingPayload.swift
//  
//
//  Created by lvv.me on 2022/2/22.
//

import Foundation

struct GHPingPayload: Decodable {
    var zen: String
    var repository: GHRepository
    var sender: GHUser
}
