//
//  ViewController.swift
//  04
//
//  Created by Viktor PELIVAN on 10/3/19.
//  Copyright © 2019 Viktor PELIVAN. All rights reserved.
//

import UIKit

class ViewController: UIViewController, APITwitterDelegate, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var tweet: [Tweet] = []
    var token: String = ""
    let request: String = "&src=typd&lang=en&count=100&result_type=recent"
    let apiKey = "7flUxw0XMZwlQnIFbQOAHjXEQ"
    let apiSecretKey = "zfVVqhesJnxOgnsqnkq5RApFpDaKdDPrYH4jkVIHfdzSGMvTxp"
    
    func getTweet(_ tweets: [Tweet]) {
        self.tweet = tweets
        tableView.reloadData()
    }
    
    func getError(_ error: NSError) {
        print("Error")
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        searchBar.text = "school 42"
        tableView.dataSource = self
        let beared = ((apiKey + ":" + apiSecretKey).data(using: String.Encoding.utf8))!.base64EncodedString()
        let url = NSURL(string: "https://api.twitter.com/oauth2/token")
        let request = NSMutableURLRequest(url: url! as URL)
        request.httpMethod = "POST"
        request.setValue("Basic " + beared, forHTTPHeaderField: "Authorization")
        request.httpBody = "grant_type=client_credentials".data(using: String.Encoding.utf8)
        let sess = URLSession.shared
        sess.dataTask(with: request as URLRequest) {
            (data, response, error) in
            do
            {
                if let dic: NSDictionary = try JSONSerialization.jsonObject(with: data!) as? NSDictionary {
                    self.token = dic["access_token"]! as! String
                }
                let conntrollerTwitter = APIController(delegate: self, token: self.token)
                conntrollerTwitter.executeRequest(find: "q="+"school 42".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)
            }
            catch (let error) {
                return print(error)
            }
        }.resume()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchText != "") {
            tweet = []
            let controller = APIController(delegate: self, token: token)
            controller.executeRequest(find: "q=" + (searchBar.text?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed))!)
            print(searchText)
        }
        else {
            print("Error: search is nil!")
        }
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweet.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TableViewCell
        if tweet.count > 0 {
            cell.cellName.text = tweet[indexPath.row].name
            cell.cellDate.text = tweet[indexPath.row].date
            cell.cellMessage.text = tweet[indexPath.row].text
        }
        return cell
    }
}
