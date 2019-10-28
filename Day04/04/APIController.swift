//
//  APIController.swift
//  04
//
//  Created by Viktor PELIVAN on 10/3/19.
//  Copyright © 2019 Viktor PELIVAN. All rights reserved.
//

import Foundation

class APIController {
    weak var delegate : APITwitterDelegate?
    let token : String
    
    init(delegate: APITwitterDelegate?, token: String) {
        self.delegate = delegate
        self.token = token
    }
    
    func executeRequest(find: String) {
        let requestUrl = NSURL(string: "https://api.twitter.com/1.1/search/tweets.json?" + find + "&lang=en&count=100&result_type=recent")
        let query = NSMutableURLRequest(url: requestUrl! as URL)
        query.httpMethod = "GET"
        query.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        let session = URLSession.shared
        session.dataTask(with: query as URLRequest)
        {
            (data, response, error) in
            let d = data
            do
            {
                var tweets: [Tweet] = []
                if let resp: NSDictionary = try JSONSerialization.jsonObject(with: d!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                    if let statuses: [NSDictionary] = resp["statuses"] as? [NSDictionary] {
                        for status in statuses {
                            let name = (status["user"] as? NSDictionary)?["name"] as? String
                            let text = status["text"] as? String
                            let date = status["created_at"] as? String
                            if (name != nil) && (text != nil) && (date != nil) {
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "E MMM dd HH:mm:ss Z yyyy"
                                if let date = dateFormatter.date(from: date!) {
                                    dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
                                    let newDate = dateFormatter.string(from: date)
                                    tweets.append(Tweet(name: name!, text: text!, date: newDate))
                                }
                            }
                        }
                        DispatchQueue.main.async {
                            self.delegate?.getTweet(tweets)
                        }
                    }
                }
            }
            catch (let err) {
                return print(err)
            }
            }.resume()
    }
}
