//
//  ViewController.swift
//  Day07
//
//  Created by Viktor PELIVAN on 10/9/19.
//  Copyright © 2019 Viktor PELIVAN. All rights reserved.
//

import UIKit
import RecastAI
import ForecastIO
import MapKit

class ViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var label: UILabel!
    
    let bot = RecastAIClient(token: "6e390776943f6a7baf9b4c2b7337d0fb")
    let darkSkyClient = DarkSkyClient(apiKey: "769abd7d0703b774bbf4768f40817822")
    
    @IBAction func tapFind(_ sender: Any) {
        if (textField.text == "")
        {
            textField.text = "Kiev"
        }
        bot.textRequest(textField.text!, successHandler: { (res) in
            
            if res.intent()?.slug == "get-weather" {
                if let location = res.get(entity: "location") {
                    self.getWeatherFromLocal(lat: location["lat"] as! Double, lng: location["lng"] as! Double)
                    print(location["lat"]!, location["lng"]!)
                } else {
                    self.label.text = "City not found!"
                }
            }
        }) { (er) in
            self.label.text = "API error!"
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func getWeatherFromLocal(lat: Double, lng: Double) {
        darkSkyClient.getForecast(location: CLLocationCoordinate2D(latitude: lat, longitude: lng)) {
            (result) in
            switch result {
            case .success(let forecast, _):
                if let currently = forecast.currently {
                    let weather = currently.summary!
                    let temp = currently.temperature!
                    
                    DispatchQueue.main.async {
                        self.label.text = "\(self.textField.text!): weather is \(weather) and the temperature is \(Int((temp - 32) * 5/9))°C (\(temp) F)."
                    }
                } else {
                    print("err")
                    self.label.text = "City not found!"
                }
            default:
                print("default=", result)
                self.label.text = "API error!"
            }
        }
    }
    
}
