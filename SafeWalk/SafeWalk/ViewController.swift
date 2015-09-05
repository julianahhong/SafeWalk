//
//  ViewController.swift
//  SafeWalk
//
//  Created by Juliana Hong on 9/5/15.
//  Copyright (c) 2015 Juliana Hong. All rights reserved.
//

import UIKit
import GoogleMaps

class ViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: GMSMapView!
    
    let locationManager = CLLocationManager()

    override func viewDidLoad(){
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
    }
    
    // 1
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        // 2
        if status == .AuthorizedWhenInUse {
            
            // 3
            locationManager.startUpdatingLocation()
            
            //4
            mapView.myLocationEnabled = true
            mapView.settings.myLocationButton = true
        }
    }
    
    // 5
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        if let location = locations.first as? CLLocation {
            
            var camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)

            var mapView = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
            self.view = mapView
            
            //marker
            var marker = GMSMarker()
            marker.position = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
//            marker.title = "Sydney"
//            marker.snippet = "Australia"
            marker.map = mapView

            
            
            
            
            
            // 7
            locationManager.stopUpdatingLocation()
        }
    }
    
    
//    @IBAction func pickPlace(sender: UIBarButtonItem) {
//        let center = CLLocationCoordinate2DMake(51.5108396, -0.0922251)
//        let northEast = CLLocationCoordinate2DMake(center.latitude + 0.001, center.longitude + 0.001)
//        let southWest = CLLocationCoordinate2DMake(center.latitude - 0.001, center.longitude - 0.001)
//        let viewport = GMSCoordinateBounds(coordinate: northEast, coordinate: southWest)
//        let config = GMSPlacePickerConfig(viewport: viewport)
//        var placePicker = GMSPlacePicker(config: config)
//        
//        placePicker?.pickPlaceWithCallback({ (place: GMSPlace?, error: NSError?) -> Void in
//            if let error = error {
//                println("Pick Place error: \(error.localizedDescription)")
//                return
//            }
//            
//            if let place = place {
//                println("Place name \(place.name)")
//                println("Place address \(place.formattedAddress)")
//                println("Place attributions \(place.attributions)")
//            } else {
//                println("No place selected")
//            }
//        })
//    }
}
