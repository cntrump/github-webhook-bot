//
//  GHReleasePayload.swift
//  
//
//  Created by lvv.me on 2022/3/10.
//

import Foundation

struct GHReleasePayload: Decodable {
    var action: String
    var release: GHRelease
    var repository: GHRepository
    var sender: GHUser
}
