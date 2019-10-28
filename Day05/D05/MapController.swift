//
//  MapController.swift
//  D05
//
//  Created by Viktor PELIVAN on 10/7/19.
//  Copyright © 2019 Viktor PELIVAN. All rights reserved.
//

import UIKit
import MapKit

class MapController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var segmentController: UISegmentedControl!
    
    let locationManager = CLLocationManager()
    var currentCoordinate: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        configureLocationServices()
        self.segmentController.layer.cornerRadius = 4;
        self.segmentController.layer.borderColor = UIColor.blue.cgColor;
        self.segmentController.layer.borderWidth = 1;
        addAnnotations()
    }
    
    func setCoords(with coordinate: CLLocationCoordinate2D, latitude: Double, longtitute: Double) {
        currentCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longtitute)
    }
    
    @IBAction func tapGetUserPos(_ sender: UIButton) {
        beginLocationUpdates(locationManager: locationManager)
        zoomToLatestLocation(with: CLLocationCoordinate2D(latitude: (locationManager.location?.coordinate.latitude)!, longitude: (locationManager.location?.coordinate.longitude)!))
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
    
    private func addAnnotations() {
        for i in 0..<points.count
        {
            let annotPoint = MKPointAnnotation()
            annotPoint.title = points[i].Title
            annotPoint.subtitle = points[i].Subtitle
            annotPoint.coordinate = CLLocationCoordinate2D(latitude: points[i].Latitude, longitude: points[i].Longitude)
            mapView.addAnnotation(annotPoint)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var color = UIColor.white
        
        for i in points {
            if (i.Latitude == annotation.coordinate.latitude && i.Longitude == annotation.coordinate.longitude) {
                color = i.Color
            }
        }
        if (color == UIColor.white) {
            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "") as? MKPinAnnotationView;
            annotationView?.annotation = annotation;
            return annotationView
        }
        var view: MKPinAnnotationView
        view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
        view.canShowCallout = true
        view.calloutOffset = CGPoint(x: -5, y: 5)
        view.pinTintColor = color
        return view
    }
    
    private func configureLocationServices() {
        locationManager.delegate = self
        
        let status = CLLocationManager.authorizationStatus()
        if status == .notDetermined {
            locationManager.requestAlwaysAuthorization()
        } else if status == .authorizedAlways || status == .authorizedWhenInUse{
            beginLocationUpdates(locationManager: locationManager)
        }
    }
    
    private func beginLocationUpdates(locationManager: CLLocationManager) {
        mapView.showsUserLocation = true
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    func zoomToLatestLocation(with coordinate: CLLocationCoordinate2D) {
        let zoomRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: 5000, longitudinalMeters: 5000)
        mapView.setRegion(zoomRegion, animated: true)
    }    
}

extension MapController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latestLocation = locations.first else { return }
        if currentCoordinate == nil {
            currentCoordinate = CLLocationCoordinate2D(latitude: (points[0].Latitude), longitude: (points[0].Longitude))
            zoomToLatestLocation(with: currentCoordinate!)
        }
        currentCoordinate = latestLocation.coordinate
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            beginLocationUpdates(locationManager: locationManager)
        }
    }
}
