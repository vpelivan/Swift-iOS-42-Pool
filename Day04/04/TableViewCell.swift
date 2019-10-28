//
//  TableViewCell.swift
//  04
//
//  Created by Viktor PELIVAN on 10/3/19.
//  Copyright © 2019 Viktor PELIVAN. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var cellName: UILabel!
    @IBOutlet weak var cellDate: UILabel!
    @IBOutlet weak var cellMessage: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
