//
//  ViewController.swift
//  SafeWalk
//
//  Created by Juliana Hong on 9/5/15.
//  Copyright (c) 2015 Juliana Hong. All rights reserved.
//
import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, UISearchBarDelegate, CLLocationManagerDelegate {
    //@IBOutlet var searchBar: UISearchBar!
    //@IBOutlet var theMap: MKMapView!

    //var searchController:UISearchController!
    var annotation:MKAnnotation!
    var localSearchRequest:MKLocalSearchRequest!
    var localSearch:MKLocalSearch!
    var localSearchResponse:MKLocalSearchResponse!
    var error:NSError!
    var pointAnnotation:MKPointAnnotation!
    var pinAnnotationView:MKPinAnnotationView!
    var locationManager :CLLocationManager = CLLocationManager()
    
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        
        let initialLocation = CLLocation(latitude: 39.914064, longitude: -75.1719795)
        centerMapOnLocation(initialLocation)
        setup()
        
        // show artwork on map
        let safety = Safety(title: "Tony Luke's",
            locationName: "Philly Cheesesteak",
            discipline: "Food",
            coordinate: CLLocationCoordinate2D(latitude: 39.914064, longitude: -75.148796))
        
        mapView.addAnnotation(safety)
        
        mapView.delegate = self
        
        var longPressRecogniser = UILongPressGestureRecognizer(target: self, action: "handleLongPress:")
        
        longPressRecogniser.minimumPressDuration = 1.0
        mapView.addGestureRecognizer(longPressRecogniser)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func searchBarSearchButtonClicked(searchBar: UISearchBar){
        searchBar.endEditing(true)

        if self.mapView.annotations.count != 0{
            annotation = self.mapView.annotations[0] as! MKAnnotation
            self.mapView.removeAnnotation(annotation)
        }
        localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = searchBar.text
        localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.startWithCompletionHandler { (localSearchResponse, error) -> Void in
            
            if localSearchResponse == nil{
                var alert = UIAlertView(title: nil, message: "Place not found", delegate: self, cancelButtonTitle: "Try again")
                alert.show()
                return
            }
            self.pointAnnotation = MKPointAnnotation()
            self.pointAnnotation.title = searchBar.text
            self.pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: localSearchResponse.boundingRegion.center.latitude, longitude:     localSearchResponse.boundingRegion.center.longitude)
            
            
            self.pinAnnotationView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: nil)
            self.mapView.centerCoordinate = self.pointAnnotation.coordinate
            self.mapView.addAnnotation(self.pinAnnotationView.annotation)
            
            
            var span = MKCoordinateSpanMake(0.075, 0.075)
            var lat = localSearchResponse.boundingRegion.center.latitude
            var long = localSearchResponse.boundingRegion.center.longitude
            var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: lat, longitude: long), span: span)
                
            self.mapView.setRegion(region, animated: true)
        }
        
    }
        //when touch background, keyboard dismisses
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        searchBar.endEditing(true)
    }
    
    func setup() {
        self.locationManager.delegate = self
        self.locationManager.distanceFilter = kCLDistanceFilterNone
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.startUpdatingLocation()
        self.mapView!.showsUserLocation = true
    }
    let regionRadius: CLLocationDistance = 10000
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        self.mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func handleLongPress(getstureRecognizer : UIGestureRecognizer){
        if getstureRecognizer.state != .Began { return }
        
        let touchPoint = getstureRecognizer.locationInView(self.mapView)
        let touchMapCoordinate = mapView.convertPoint(touchPoint, toCoordinateFromView: mapView)
        
        //        let annotation = MKPointAnnotation()
        //        annotation.coordinate = touchMapCoordinate
        
        //        var storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        //        var vc: SecondViewController = storyboard.instantiateViewControllerWithIdentifier("EditPin") as! SecondViewController
        //        self.presentViewController(vc, animated: true, completion: nil)
        // Create the alert controller
        var inputTextField: UITextField?
        var inputType: UITextField?
        let editPin = UIAlertController(title: "Add Pin Details", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        editPin.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        editPin.addAction(UIAlertAction(title: "Confirm", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            // Now do whatever you want with inputTextField (remember to unwrap the optional)
            let safety = Safety(title: inputTextField!.text,
                locationName: inputType!.text,
                discipline: "Food",
                coordinate: touchMapCoordinate)
            self.mapView.addAnnotation(safety)
        }))
        editPin.addTextFieldWithConfigurationHandler {
            (txtDetails) -> Void in
            txtDetails.placeholder = "Details"
            inputTextField = txtDetails
        }
        editPin.addTextFieldWithConfigurationHandler {
            (txtType) -> Void in
            txtType.placeholder = "Type"
            inputType = txtType
        }
        
        presentViewController(editPin, animated: true, completion: nil)
    }


}


