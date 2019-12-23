//
//  MapController.swift
//  D05
//
//  Created by Viktor PELIVAN on 10/7/19.
//  Copyright © 2019 Viktor PELIVAN. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import AVFoundation

protocol HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark)
    func dropPinZoomIn2(placemark:MKPlacemark)
}

class MapController: UIViewController, MKMapViewDelegate {
    
    
    @IBOutlet weak var directionsLabel: UILabel!
    @IBOutlet weak var viewDirections: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var buildRoute: UIButton!
    var selectedPin : MKPlacemark? = nil
    var selectedOutPin : MKPlacemark? = nil
    var flagWatch: Bool = false
    var inter: Int = 15
    @IBOutlet weak var urlAdress: UILabel!
    @IBOutlet weak var nameAdress: UILabel!
    @IBOutlet weak var viewMenu: UIView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var heightViewManu: NSLayoutConstraint!
    @IBOutlet weak var segmentController: UISegmentedControl!
    var resultSearchController:UISearchController? = nil
    var resultSearchController2:UISearchController? = nil
    let locationManager = CLLocationManager()
    var currentCoordinate: CLLocationCoordinate2D?
    var steps = [MKRoute.Step]()
    let speechSynth = AVSpeechSynthesizer()
    
    @IBAction func cancelActionButton(_ sender: UIButton) {
        self.flagWatch = false
        cancelButton.isHidden = true
        self.toogleMenu(status: 0)
        selectedOutPin = nil
        DispatchQueue.main.async {
            self.deleteRoute()
            self.mapView.removeAnnotations(self.mapView.annotations)
            self.viewDirections.isHidden = true
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        print(viewMenu.subviews)
        if UIDevice.current.orientation.isLandscape {
            viewMenu.subviews[1].frame = CGRect(x: 0, y: 0, width: viewMenu.frame.width * 1.95, height: 50)
           heightViewManu.constant = -210
        } else {
            viewMenu.subviews[1].frame = CGRect(x: 0, y: 0, width: viewMenu.frame.width / 1.95, height: 50)
            heightViewManu.constant = -240
        }
    }
    
    
    override func viewDidLoad() {
        let locationSearchTable2 = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable2") as! LocationSearchTable2
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable as UISearchResultsUpdating
        
        resultSearchController2 = UISearchController(searchResultsController: locationSearchTable2)
        resultSearchController2?.searchResultsUpdater = locationSearchTable2 as UISearchResultsUpdating
        
        resultSearchController2!.searchBar.placeholder = "From: My Location"
        viewMenu.addSubview(resultSearchController2!.searchBar)
//        viewMenu.subviews[0].frame.width = viewDirections.frame.width
//        print(viewMenu.subviews, viewMenu.subviews[0], viewDirections.frame.size)
        
        
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "To: ..."
        navigationItem.titleView = resultSearchController?.searchBar
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        
        definesPresentationContext = true
        locationSearchTable.mapView = mapView
        locationSearchTable2.mapView = mapView
        locationSearchTable.handleMapSearchDelegate = self
        locationSearchTable2.handleMapSearchDelegate = self
        
        super.viewDidLoad()
        mapView.delegate = self
        locationManager.delegate = self
        self.segmentController.layer.cornerRadius = 4;
        self.segmentController.layer.borderColor = UIColor.blue.cgColor;
        self.segmentController.layer.borderWidth = 1;
        if UIDevice.current.orientation.isLandscape {
            viewMenu.subviews[1].frame = CGRect(x: 0, y: 0, width: viewMenu.frame.width * 1.95, height: 50)
            heightViewManu.constant = -210
        } else {
            viewMenu.subviews[1].frame = CGRect(x: 0, y: 0, width: viewMenu.frame.width / 1.95, height: 50)
            heightViewManu.constant = -240
        }
        configureLocationServices()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureLocationServices()
    }
    
    func setCoords(with coordinate: CLLocationCoordinate2D, latitude: Double, longtitute: Double) {
        currentCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longtitute)
    }
    
    @IBAction func tapBuildRoute(_ sender: UIButton) {
        deleteRoute()
        self.viewDirections.isHidden = false
        self.flagWatch = false
        self.toogleMenu(status: 0)
        self.cancelButton.isHidden = false
        getDirections(to: selectedPin!)
    }
    
    
    @IBAction func tapGetUserPos(_ sender: UIButton) {
        if (checkAuth())
        {
        beginLocationUpdates(locationManager: locationManager)
        zoomToLatestLocation(with: CLLocationCoordinate2D(latitude: (locationManager.location?.coordinate.latitude)!,
                                                          longitude: (locationManager.location?.coordinate.longitude)!))
        }
        else
        {
            let alert = UIAlertController(title: "The geolcoation servise is desabled", message: "Proseed to settings to turn it on", preferredStyle: .alert)
            
            let settingsAction = UIAlertAction(title: "Settings", style: .default) {(alert) in
                if let url = URL(string: "App-Prefs:root=LOCATION_SERVICES"){
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(settingsAction)
            alert.addAction(cancelAction)
            present(alert, animated: true,completion: nil)
        }
    }
    
    func toogleMenu(status: Int)
    {
        if (status == 1)
        {
            UIView.animate(withDuration: 0.2, delay: 0.2, options: .curveEaseOut,
                           animations: {self.viewMenu.isHidden = false},
                           completion: { _ in self.viewMenu.alpha = 1            })
        }
        else if (status == 0)
        {
            UIView.animate(withDuration: 0.2, delay: 0.2, options: .curveEaseOut,
                           animations: {self.viewMenu.alpha = 0},
                           completion: { _ in self.viewMenu.isHidden = true})
        }
    }
    
    @IBAction func SegmentedChoose(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            mapView.mapType = .standard
        case 1:
            mapView.mapType = .satellite
        case 2:
            mapView.mapType = .hybrid
        default:
            break
        }
    }
    
    private func configureLocationServices() { //Check if User Geolocation is enabled
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            if (checkAuth())
            {
                print("Location Allow")
            }
        } else {
            let alert = UIAlertController(title: "The geolcoation servise is desabled", message: "Proseed to settings to turn it on", preferredStyle: .alert)
            
            let settingsAction = UIAlertAction(title: "Settings", style: .default) {(alert) in
                if let url = URL(string: "App-Prefs:root=LOCATION_SERVICES"){
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(settingsAction)
            alert.addAction(cancelAction)
            present(alert, animated: true,completion: nil)
        }
    }
    
    private func beginLocationUpdates(locationManager: CLLocationManager) {
        mapView.showsUserLocation = true
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    func zoomToLatestLocation(with coordinate: CLLocationCoordinate2D) {
        let zoomRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(zoomRegion, animated: true)
    }
    
    func checkAuth() -> Bool{
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways:
            break
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            return true
        case .denied:
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            break
        default:
            break
        }
        return false
    }

}

extension MapController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latestLocation = locations.first else { return }
        if currentCoordinate == nil {
            beginLocationUpdates(locationManager: locationManager)
            currentCoordinate = CLLocationCoordinate2D(latitude: (locationManager.location?.coordinate.latitude)!,
                                                       longitude: (locationManager.location?.coordinate.longitude)!)
            zoomToLatestLocation(with: currentCoordinate!)
        }
        if (flagWatch && selectedOutPin == nil)
        {
            self.zoomToLatestLocation(with: CLLocationCoordinate2D(latitude: (self.locationManager.location?.coordinate.latitude)!,
                                                                   longitude: (self.locationManager.location?.coordinate.longitude)!))
            if (selectedPin != nil)
            {
                getDirections(to: selectedPin!)
            }
        }
        currentCoordinate = latestLocation.coordinate
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            beginLocationUpdates(locationManager: locationManager)
        }
    }
    
    func getDirections(to destination: MKPlacemark) {
        self.flagWatch = true
        var sourcePlacemark: MKPlacemark
        if (selectedOutPin == nil)
        {
            sourcePlacemark = MKPlacemark(coordinate: currentCoordinate!)
        }
        else
        {
            sourcePlacemark = selectedOutPin!
        }
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let res = MKMapItem(placemark: destination)
        
        let directionsRequest = MKDirections.Request()
        directionsRequest.source = sourceMapItem
        directionsRequest.destination = res
        directionsRequest.transportType = .automobile
        
        let directions = MKDirections(request: directionsRequest)
        let queue = DispatchQueue.global(qos: .utility)
        queue.async{
            DispatchQueue.main.async {
                directions.calculate {(response, _) in
                    
                    guard let response = response else {
                        self.viewDirections.isHidden = true
                        self.selectedPin = nil
                        self.selectedOutPin = nil
                        self.flagWatch = false
                        self.mapView.removeAnnotations(self.mapView.annotations)
                        let alert = UIAlertController(title: "Unable to build route", message: "Change destination point!", preferredStyle: .alert)
                        self.zoomToLatestLocation(with: CLLocationCoordinate2D(latitude: (self.locationManager.location?.coordinate.latitude)!,
                                                                          longitude: (self.locationManager.location?.coordinate.longitude)!))
                        let cancelAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                        alert.addAction(cancelAction)
                        self.present(alert, animated: true,completion: nil)
                        return }
                    guard let primaryRoute = response.routes.first else {
                        self.viewDirections.isHidden = true
                        self.selectedPin = nil
                        self.selectedOutPin = nil
                        self.flagWatch = false
                        self.mapView.removeAnnotations(self.mapView.annotations)
                        self.zoomToLatestLocation(with: CLLocationCoordinate2D(latitude: (self.locationManager.location?.coordinate.latitude)!,
                                                                          longitude: (self.locationManager.location?.coordinate.longitude)!))
                        let alert = UIAlertController(title: "Unable to build route", message: "Change destination point!", preferredStyle: .alert)
                        
                        let cancelAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                        alert.addAction(cancelAction)
                        self.present(alert, animated: true,completion: nil)
                        return }
                    
                    if (self.flagWatch)
                    {
                        self.mapView.removeOverlays(self.mapView.overlays)
                        self.mapView.addOverlay(primaryRoute.polyline)
                        
                        self.inter += 1
                        if (self.inter > 15 && self.selectedOutPin == nil)
                        {
                            self.locationManager.monitoredRegions.forEach({ self.locationManager.stopMonitoring(for:  $0)})
                            self.steps = primaryRoute.steps
                            for i in 0..<primaryRoute.steps.count {
                                let step = primaryRoute.steps[i]
                                let region = CLCircularRegion(center: step.polyline.coordinate, radius: 100, identifier: "\(i)")
                                self.locationManager.startMonitoring(for: region)
                                let circle = MKCircle(center: region.center, radius: region.radius)
                                self.mapView.addOverlay(circle)
                            }

                            let initialMessage = "Через \(self.steps[1].distance) метров, \(self.steps[1].instructions)."
                            self.directionsLabel.text = initialMessage
                            let speechUtter = AVSpeechUtterance(string: initialMessage)
                            self.speechSynth.speak(speechUtter)
                           self.inter = 0
                        }
                    }
                }
            }
        }
    }
    
    func deleteRoute() {
        self.mapView.removeOverlays(self.mapView.overlays)
    }
}

extension MapController: HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark){
        if (viewDirections.isHidden == true)
        {
            selectedPin = placemark
            mapView.removeAnnotations(mapView.annotations)
            var annotation = MKPointAnnotation()
            if (selectedOutPin != nil)
            {
                annotation.coordinate = selectedOutPin!.coordinate
                annotation.title = selectedOutPin?.name
                if let city = selectedOutPin?.locality,
                    let state = selectedOutPin?.administrativeArea {
                    annotation.subtitle = "\(city) \(state)"
                }
                mapView.addAnnotation(annotation)
            }
            annotation = MKPointAnnotation()
            annotation.coordinate = placemark.coordinate
            annotation.title = placemark.name
            if let city = placemark.locality,
                let state = placemark.administrativeArea {
                annotation.subtitle = "\(city) \(state)"
            }
            mapView.addAnnotation(annotation)
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
            mapView.setRegion(region, animated: true)
            
                toogleMenu(status: 1)
            self.nameAdress.text = placemark.name
            self.urlAdress.text = placemark.title
        }
    }
    
    func dropPinZoomIn2(placemark:MKPlacemark){
        selectedOutPin = placemark
        mapView.removeAnnotations(mapView.annotations)
        var annotation = MKPointAnnotation()
        if (selectedPin != nil)
        {
            annotation.coordinate = selectedPin!.coordinate
            annotation.title = selectedPin?.name
            if let city = selectedPin?.locality,
                let state = selectedPin?.administrativeArea {
                annotation.subtitle = "\(city) \(state)"
            }
            mapView.addAnnotation(annotation)
        }
        annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(state)"
        }
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
        mapView.setRegion(region, animated: true)
        toogleMenu(status: 1)
        self.nameAdress.text = placemark.name
        self.urlAdress.text = placemark.title
    }
}

extension MapController {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = .green
            renderer.lineWidth = 5
            return renderer
        }
        if overlay is MKCircle {
            let renderer = MKCircleRenderer(overlay: overlay)
//            renderer.strokeColor = .red
//            renderer.fillColor = .red
//            renderer.alpha = 0.5
            return renderer
        }
        return MKOverlayRenderer()
    }
    
}
