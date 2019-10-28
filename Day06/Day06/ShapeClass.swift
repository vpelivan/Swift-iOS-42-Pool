//
//  ShapeClasses.swift
//  Day06
//
//  Created by Viktor PELIVAN on 10/8/19.
//  Copyright © 2019 Viktor PELIVAN. All rights reserved.
//

import Foundation
import UIKit

class Shape: UIView {
    var kind: String = "Rectangle"
    var collType: UIDynamicItemCollisionBoundsType = .rectangle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        bounds = CGRect(x: 0, y: 0, width: 100, height: 100)
        if (arc4random_uniform(2) == 0) {
            kind = "Circle"
        }
        switch(arc4random_uniform(9)) {
        case 0:
            backgroundColor = UIColor.red
        case 1:
            backgroundColor = UIColor.green
        case 2:
            backgroundColor = UIColor.blue
        case 3:
            backgroundColor = UIColor.yellow
        case 4:
            backgroundColor = UIColor.black
        case 5:
            backgroundColor = UIColor.gray
        case 6:
            backgroundColor = UIColor.cyan
        case 7:
            backgroundColor = UIColor.purple
        case 8:
            backgroundColor = UIColor.orange
        default:
            break
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var collisionBoundsType: UIDynamicItemCollisionBoundsType {
        return collType
    }
    
    override var bounds: CGRect {
        get { return super.bounds }
        set(newBounds) {
            super.bounds = newBounds
            if self.kind == "Circle" {
                layer.cornerRadius = newBounds.size.width / 2.0
                self.collType = .ellipse
            }
        }
    }
}
