//
//  EventController.swift
//  rush00
//
//  Created by Viktor PELIVAN on 10/5/19.
//  Copyright © 2019 Viktor PELIVAN. All rights reserved.
//

import UIKit

class EventController: UIViewController {

    @IBOutlet weak var evName: UILabel!
    @IBOutlet weak var evDate: UILabel!
    @IBOutlet weak var evSubscribed: UILabel!
    @IBOutlet weak var evMaxSubscribers: UILabel!
    @IBOutlet weak var evLocation: UILabel!
    @IBOutlet weak var evKind: UILabel!
    @IBOutlet weak var evDescription: UILabel!
    @IBOutlet weak var evDuration: UILabel!
    @IBOutlet weak var evBeginsAt: UILabel!
    @IBOutlet weak var evEndsAt: UILabel!
    
    @IBAction func tapSubscribe(_ sender: UIButton) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        if cellNum != nil {
//            evName.text = eventsDict[cellNum!].name
//            evDate.text = String("Date: " + String(eventsDict[cellNum!].beginTime))
//            evSubscribed.text = String("Subscribed: " + String(eventsDict[cellNum!].numberOfSubsc))
//            if eventsDict[cellNum!].maxSubscribers != nil {
//                evMaxSubscribers.text = String("Max Subscribers: " + String(eventsDict[cellNum!].maxSubscribers!))
//            } else {
//                evMaxSubscribers.text = String("Max Subscribers: 0")
//            }
//            evLocation.text = String("Loacation:\n" + eventsDict[cellNum!].location)
//            evKind.text = String("Kind: " + eventsDict[cellNum!].kind)
//            evDescription.text = String("Description:\n " + eventsDict[cellNum!].description)
//        }

    }
}
