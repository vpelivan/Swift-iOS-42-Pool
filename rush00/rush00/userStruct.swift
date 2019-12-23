//
//  userStruct.swift
//  rush00
//
//  Created by Viktor PELIVAN on 10/5/19.
//  Copyright © 2019 Viktor PELIVAN. All rights reserved.
//

import Foundation

struct UserData {
    var displayname: String
    var login: String
    var image_url: String
    var level: NSNumber
}

struct EventData {
    var name: String
    var description: String
    var maxSubscribers: Int?
    var numberOfSubsc: Int
    var location: String
    var kind: String
    var duration: String
    var beginTime: String
    var endTime: String
}

var datesStr: [UserData] = []
var eventsDict: [EventData] = []
