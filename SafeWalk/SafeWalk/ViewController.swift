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

//        var camera = GMSCameraPosition.cameraWithLatitude(-33.8683, longitude:151.2086, zoom:6)
//        mapView = GMSMapView.mapWithFrame(CGRectZero, camera:camera)
//        self.view = mapView
//        
//        mapView.mapType = kGMSTypeSatellite
//        mapView.myLocationEnabled = true

        
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
            
            // 6
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            
            // 7
            locationManager.stopUpdatingLocation()
        }
    }
}
