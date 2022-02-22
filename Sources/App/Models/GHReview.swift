//
//  GHReview.swift
//  
//
//  Created by lvv.me on 2022/2/22.
//

import Foundation

struct GHReview: Decodable {
    var user: GHUser
    var body: String?
    var state: String
    var htmlUrl: String
}
