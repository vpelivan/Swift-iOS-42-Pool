//
//  Data.swift
//  D05
//
//  Created by Viktor PELIVAN on 10/7/19.
//  Copyright © 2019 Viktor PELIVAN. All rights reserved.
//

import Foundation
import UIKit

struct Point {
    var Title: String
    var Subtitle: String
    var Longitude: Double
    var Latitude: Double
    var Color: UIColor
}

let points: [Point] = [
    Point(Title: "42 School", Subtitle: "42 Started Here", Longitude: 2.318405, Latitude: 48.896607, Color: UIColor.red),
    Point(Title: "Google", Subtitle: "Google Main Campus", Longitude: -122.083, Latitude: 37.4218, Color: UIColor.blue),
    Point(Title: "Apple Infinite Loop", Subtitle: "Apple Head Office", Longitude: -122.032, Latitude: 37.331, Color: UIColor.green),
    Point(Title: "Statue of Freedom", Subtitle: "The Symbol of American Freedom", Longitude: -74.046, Latitude: 40.689, Color: UIColor.yellow)
]

