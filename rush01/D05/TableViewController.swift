//
//  TabBarController.swift
//  D05
//
//  Created by Viktor PELIVAN on 10/7/19.
//  Copyright © 2019 Viktor PELIVAN. All rights reserved.
//

import UIKit
import MapKit

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return points.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GeoCell", for: indexPath)
        cell.textLabel?.text = points[indexPath.row].Title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true);
        let mapViewController = self.tabBarController?.viewControllers![0] as! MapController
        mapViewController.zoomToLatestLocation(with: CLLocationCoordinate2D(latitude: points[indexPath.row].Latitude, longitude: points[indexPath.row].Longitude))
        self.tabBarController?.selectedViewController = mapViewController;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    
    }

}
