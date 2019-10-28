//
//  ViewController.swift
//  ex02
//
//  Created by Viktor PELIVAN on 9/11/19.
//  Copyright © 2019 Viktor PELIVAN. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var digitalLabel: UILabel!
    
    var opFlag: Bool = false
    var actFlag: Bool = false
    var firstNum: intmax_t = 0
    var secondNum: intmax_t = 0
    var tag: Int = 0
    let MAXINT: Int = 2147483647
    let MININT: Int = -2147483648
    
    func checkInt(op: Int) -> Int {
        if (op > MAXINT) {
            firstNum = MAXINT;
            print("Max Int Error");
            return 0
        }
        else if (op < MININT) {
            firstNum = MININT;
            print("Min Int Error");
            return 0
        }
        return 1
    }
    
    @IBAction func pushAc(_ sender: UIButton) {
        tag = 0
        digitalLabel.text = String("0")
        opFlag = false
        actFlag = false
        firstNum = 0
        secondNum = 0
        print("button AC Pressed")
    }
    
    @IBAction func pushNeg(_ sender: UIButton) {
        print("button NEG Pressed")
        if ((firstNum < 0 && firstNum * -1 <= MAXINT)
            || (firstNum >= 0 && firstNum * -1 >= MININT)) {
            firstNum = -firstNum
            print("negative number transformation performed")
        }
        else {
            if (firstNum > 0) {
                firstNum = MAXINT
            }
            else {
                firstNum = MININT
            }
            print("Max Or Min Int Error")
        }
        digitalLabel.text = String(firstNum)
    }
    
    @IBAction func pushDigit(_ sender: UIButton) {
        if opFlag == true {
            opFlag = false
            firstNum = 0
            if tag == 15 {
                secondNum = 0
            }
            else {
                actFlag = true
            }
        }
        if ((firstNum >= 0 && (firstNum * 10 + sender.tag) <= MAXINT)
        || (firstNum < 0 && (firstNum * 10 - sender.tag) >= MININT)) {
            if firstNum >= 0 {
                firstNum = firstNum * 10 + sender.tag
            }
            else {
                firstNum = firstNum * 10 - sender.tag
            }
        }
        else {
            if firstNum >= 0 {
                firstNum = MAXINT
            }
            else {
                firstNum = MININT
            }
            print("Max or Min Int Error")
        }
        digitalLabel.text = String(firstNum)
        print("button \(sender.tag) pressed")
    }
    
    
    @IBAction func pushOp(_ sender: UIButton) {
        opFlag = true
        if sender.tag == 14 || actFlag {
            if tag == 13 && firstNum == 0 {
                digitalLabel.text = String("Error")
                opFlag = false
                actFlag = false
                firstNum = 0
                secondNum = 0
                tag = 0
                print("Zero devision error")
            }
            else {
                if tag == 10 {
                    if checkInt(op: firstNum + secondNum) == 1 {
                        firstNum = firstNum + secondNum
                        print("operation Addition performed")
                    }
                }
                else if tag == 11 {
                    if checkInt(op: firstNum * secondNum) == 1 {
                        firstNum = firstNum * secondNum
                        print("operation Multiplying performed")
                    }
                }
                else if tag == 12 {
                    if checkInt(op: secondNum - firstNum) == 1 {
                        firstNum = secondNum - firstNum
                        print("operation Substraction performed")
                    }
                }
                else if tag == 13 {
                    firstNum = secondNum / firstNum
                    print("operation Division performed")
                }
                digitalLabel.text = String(firstNum)
            }
            secondNum = firstNum
            actFlag = false
        }
        else {
            secondNum = firstNum
        }
        tag = sender.tag
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}
