//
//  CustomViewCell.swift
//  Day02
//
//  Created by Viktor PELIVAN on 9/28/19.
//  Copyright © 2019 Viktor PELIVAN. All rights reserved.
//

import UIKit

class CustomViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
