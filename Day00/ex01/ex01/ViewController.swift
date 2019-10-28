//
//  ViewController.swift
//  ex01
//
//  Created by Viktor PELIVAN on 9/11/19.
//  Copyright © 2019 Viktor PELIVAN. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var LabelToChange: UILabel!
    @IBAction func clickMe(_ sender: UIButton) {
        if LabelToChange.text == "Hello World !" {
            LabelToChange.text = "Thank You !"
        } else {
            LabelToChange.text = "Hello World !"
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}
