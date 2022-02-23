//
//  GHComment.swift
//  
//
//  Created by lvv.me on 2022/2/22.
//

import Foundation

struct GHComment: Decodable {
    var user: GHUser
    var body: String
    var htmlUrl: String
}
