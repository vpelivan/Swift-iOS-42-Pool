//
//  APITwitterDelegate.swift
//  04
//
//  Created by Viktor PELIVAN on 10/3/19.
//  Copyright © 2019 Viktor PELIVAN. All rights reserved.
//

import Foundation

protocol APITwitterDelegate: class {
    func getTweet(_ tweets : [Tweet])
    func getError(_ error : NSError)
}
