//
//  EventCell.swift
//  rush00
//
//  Created by Viktor PELIVAN on 10/5/19.
//  Copyright © 2019 Viktor PELIVAN. All rights reserved.
//

import UIKit

class EventCell: UITableViewCell {

    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var eventDate: UILabel!
    @IBOutlet weak var eventDescription: UILabel!
    @IBOutlet weak var subscribed: UILabel!
    @IBOutlet weak var duration: UILabel!
    @IBOutlet weak var maxSubsc: UILabel!
    @IBOutlet weak var beginsAt: UILabel!
    @IBOutlet weak var kind: UILabel!
    @IBOutlet weak var endsAt: UILabel!
    @IBOutlet weak var location: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
