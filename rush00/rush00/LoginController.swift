//
//  LoginController.swift
//  rush00
//
//  Created by Viktor PELIVAN on 10/5/19.
//  Copyright © 2019 Viktor PELIVAN. All rights reserved.
//

import UIKit
import AuthenticationServices

class LoginController: UIViewController {
    let callbackUri = "rush00://Rush00"
    let UID = "b187e40868f3e461656265ff9f2e08236bbf46d88ff2de3ef18b9eaab1b54d3a"
    let secretKey = "dd26d2370629895161f24f5851288711cf73b110a9ce7973779fdcfe5389ec29"
    let tokenUrl = "https://api.intra.42.fr/oauth/token"
    var webAuthSession: ASWebAuthenticationSession?
    var token: String = ""

    func loadMe() {
        let url = NSURL(string: "https://api.intra.42.fr/v2/me")
        let request = NSMutableURLRequest(url: url! as URL)
        request.httpMethod = "GET"
        request.setValue("Bearer " + self.token, forHTTPHeaderField: "Authorization")
        let sess = URLSession.shared
        sess.dataTask(with: request as URLRequest) {
            (data, response, error) in
            do
            {
                if let dic: NSDictionary = try JSONSerialization.jsonObject(with: data!) as? NSDictionary {

                    datesStr.append(UserData(displayname: dic["displayname"]! as! String, login: dic["login"]! as! String, image_url: dic["image_url"]! as! String, level: ((dic["cursus_users"] as! NSArray)[0] as! NSDictionary)["level"] as! NSNumber))
                    self.loadEvents()
                }
            }
            catch (let error) {
                return print(error)
            }
            }.resume()
    }
    
    func loadEvents() {
        let url = NSURL(string: "https://api.intra.42.fr/v2/events?page[size]=100&range[begin_at]=2019-10-05T09:27:10.537Z,2020-09-15T09:27:10.537Z")
        let request = NSMutableURLRequest(url: url! as URL)
        request.httpMethod = "GET"
        request.setValue("Bearer "+self.token, forHTTPHeaderField: "Authorization")
        let sess = URLSession.shared
        sess.dataTask(with: request as URLRequest) {
            (data, response, error) in
            do
            {
                if let dic: [NSDictionary] = try JSONSerialization.jsonObject(with: data!) as? [NSDictionary] {
                    for event in 0..<dic.count
                    {
                        let a = dic[event]
                        eventsDict.append(EventData(name:  a["name"]! as! String, description: a["description"]! as! String, maxSubscribers: a["max_people"]! as? Int, numberOfSubsc: a["nbr_subscribers"]! as! Int, location: a["location"]! as! String, kind: a["kind"]! as! String, duration: "0", beginTime: a["begin_at"]! as! String, endTime: a["end_at"]! as! String))
                    }
                    let HomeVC = self.storyboard?.instantiateViewController(withIdentifier: "NavigationCtrl") as? UINavigationController
                    self.present(HomeVC!, animated: true, completion: nil)
                }
            }
            catch (let error) {
                return print(error)
            }
            }.resume()
    }
    
    @IBAction func tapLogIn(_ sender: UIButton) {
        webAuthSession = ASWebAuthenticationSession.init(url: URL(string: "https://api.intra.42.fr/oauth/authorize?client_id=\(UID)&redirect_uri=\(callbackUri)&response_type=code&scope=public+forum+projects+profile+elearning+tig")!, callbackURLScheme: callbackUri) {
            (callback, error) in
            if let callback = callback {
                let url = NSURL(string: "https://api.intra.42.fr/oauth/token")
                let request = NSMutableURLRequest(url: url! as URL)
                request.httpMethod = "POST"
                request.httpBody = "grant_type=authorization_code&\(callback.query!)&client_id=\(self.UID)&client_secret=\(self.secretKey)&redirect_uri=\(self.callbackUri)".data(using: String.Encoding.utf8)
                let sess = URLSession.shared
                sess.dataTask(with: request as URLRequest) {
                    (data, response, error) in
                    do
                    {
                        if let dic: NSDictionary = try JSONSerialization.jsonObject(with: data!) as? NSDictionary {
                            self.token = dic["access_token"]! as! String
                            self.loadMe()
                        }
                    }
                    catch (let error) {
                        return print(error)
                    }
                    }.resume()
            }
        }
        webAuthSession?.start()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

}
