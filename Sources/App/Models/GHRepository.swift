//
//  GHRepository.swift
//  
//
//  Created by lvv.me on 2022/2/22.
//

import Foundation

struct GHRepository: Decodable {
    var fullName: String
    var htmlUrl: String
    var description: String?
}
