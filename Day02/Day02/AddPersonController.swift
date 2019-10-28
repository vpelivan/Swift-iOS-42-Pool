//
//  AddPersonController.swift
//  Day02
//
//  Created by Viktor PELIVAN on 9/28/19.
//  Copyright © 2019 Viktor PELIVAN. All rights reserved.
//

import UIKit

class AddPersonController: UIViewController {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var deathField: UITextView!
    @IBOutlet weak var dateField: UITextField!
    let datePicker = UIDatePicker()
    
    @IBAction func pushDoneButton(_ sender: Any) {
        if nameField.text?.isEmpty == false && dateField.text?.isEmpty == false {
            namesList.append(String(nameField.text!))
            date.append(String(dateField.text!))
            if deathField.text?.isEmpty == false {
                deathDescription.append(String(deathField.text!))
            } else {
                deathDescription.append(String(""))
            }
        }
        print(namesList)
        print(deathDescription)
        print(date)
        performSegue(withIdentifier: "backToTable", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.minimumDate = Date() // setting date picker to make past dates choose impossible
        dateField?.inputView = datePicker // Creating Date Picker
        datePicker.datePickerMode = .dateAndTime // Shows Date And Time
        let toolbar = UIToolbar() // Creating Toolbar above Date Picker
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction)) // Creating Done Button
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil) // Needed to put Done Button on The right side of toolbar
        toolbar.setItems([flexSpace, doneButton], animated: true) // Sets to put Done button to right side
        
        dateField?.inputAccessoryView = toolbar
    }
    @objc func doneAction() { // getting date from date picker when tapping on Done button
        getDateFromPicker()
        view.endEditing(true)
    }
    func getDateFromPicker() { //putting date in text field using date formatter
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM yyyy HH:mm:ss"
        dateField.text = formatter.string(from: datePicker.date)
    }
}
