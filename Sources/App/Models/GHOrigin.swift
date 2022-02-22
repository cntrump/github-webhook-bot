//
//  GHOrigin.swift
//  
//
//  Created by lvv.me on 2022/2/22.
//

import Foundation

struct GHOrigin: Decodable {
    var label: String
    var ref: String
    var sha: String
    var user: GHUser
    var repo: GHRepository
}
