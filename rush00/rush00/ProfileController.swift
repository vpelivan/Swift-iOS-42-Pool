//
//  ViewController.swift
//  rush00
//
//  Created by Viktor PELIVAN on 10/5/19.
//  Copyright © 2019 Viktor PELIVAN. All rights reserved.
//

import UIKit

class ProfileController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var Image: UIImageView!
    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var Login: UILabel!
    @IBOutlet weak var level: UILabel!
    
    @IBAction func tapLogOut(_ sender: UIBarButtonItem) {
        let HomeVC = self.storyboard?.instantiateViewController(withIdentifier: "goToLogIn") as? LoginController
        self.present(HomeVC!, animated: true, completion: nil)
        let count = datesStr.count
        var count2 = eventsDict.count - 1
        for i in 0..<count {
            datesStr.remove(at: i)
        }
        print(count2)
        while (count2 >= 0)
        {
            eventsDict.remove(at: count2)
            count2 -= 1
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let data = try? Data(contentsOf: URL(string: datesStr[0].image_url)!) {
            DispatchQueue.main.async {
                self.Image.image = UIImage(data: data)
                self.firstName.text = datesStr[0].displayname
                self.Login.text = datesStr[0].login
                self.level.text = String(Float(truncating: datesStr[0].level))
            }
            tableView.delegate = self
            tableView.dataSource = self
        }
        else {
            print("Could Not Load Image")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventsDict.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as! EventCell
        if eventsDict.count > 0 {
            var duration: String = ""
            let end = String((eventsDict[indexPath.row].endTime as String ).prefix(16)).replacingOccurrences(of: "T", with: " ")
            let begin = String((eventsDict[indexPath.row].beginTime as String ).prefix(16)).replacingOccurrences(of: "T", with: " ")
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            let beginDate = dateFormatter.date(from: begin)!
            let endDate = dateFormatter.date(from: end)!
            let diffInHours = Calendar.current.dateComponents([.hour], from: beginDate, to: endDate).hour
            duration = String(String(diffInHours!) + " hours")
            cell.eventName.text = eventsDict[indexPath.row].name
            cell.eventDate.text = String("When: \(begin)")
            cell.eventDescription.text = eventsDict[indexPath.row].description
            cell.subscribed.text = String("Subscribed: " + String(eventsDict[indexPath.row].numberOfSubsc))
            cell.duration.text = "Duration: \(duration)"
            if eventsDict[indexPath.row].maxSubscribers != nil {
                cell.maxSubsc.text = String("Max Subscribers: " + String(eventsDict[indexPath.row].maxSubscribers!))
            } else {
                cell.maxSubsc.text = "0"
            }
            cell.beginsAt.text = ("Begins At: \(begin)")
            cell.kind.text = String("kind of event: " + String(eventsDict[indexPath.row].kind))
            cell.endsAt.text = String("Ends At: \(end)")
            cell.location.text = String("Location: " + String(eventsDict[indexPath.row].location))
        }
        return cell
    }
}
