//
//  TweetStruct.swift
//  04
//
//  Created by Viktor PELIVAN on 10/3/19.
//  Copyright © 2019 Viktor PELIVAN. All rights reserved.
//

import Foundation

struct Tweet: CustomStringConvertible {
    let name: String
    let text: String
    let date: String
    var description: String {
        return "\(name) \(date)\n\(text)"
    }
}
