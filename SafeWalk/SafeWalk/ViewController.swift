//
//  ViewController.swift
//  SafeWalk
//
//  Created by Juliana Hong on 9/5/15.
//  Copyright (c) 2015 Juliana Hong. All rights reserved.
//
import UIKit
import MapKit

class ViewController: UIViewController, UISearchBarDelegate {
    //@IBOutlet var searchBar: UISearchBar!
    //@IBOutlet var theMap: MKMapView!

    var searchController:UISearchController!
    var annotation:MKAnnotation!
    var localSearchRequest:MKLocalSearchRequest!
    var localSearch:MKLocalSearch!
    var localSearchResponse:MKLocalSearchResponse!
    var error:NSError!
    var pointAnnotation:MKPointAnnotation!
    var pinAnnotationView:MKPinAnnotationView!
    
    @IBOutlet var mapView: MKMapView!

    @IBAction func showSearchBar(sender: AnyObject) {
        // Create the search controller and make it perform the results updating.
        searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.delegate = self
        // Present the view controller
        
    presentViewController(searchController, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar){
        //1
        searchBar.resignFirstResponder()
        dismissViewControllerAnimated(true, completion: nil)
        if self.mapView.annotations.count != 0{
            annotation = self.mapView.annotations[0] as! MKAnnotation
            self.mapView.removeAnnotation(annotation)
        }
        //2
        localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = searchBar.text
        localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.startWithCompletionHandler { (localSearchResponse, error) -> Void in
            
            if localSearchResponse == nil{
                var alert = UIAlertView(title: nil, message: "Place not found", delegate: self, cancelButtonTitle: "Try again")
                alert.show()
                return
            }
            //3
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
//        override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
//            searchBar.endEditing(true)
//            
//    
//        }
}


//import UIKit
//import MapKit
//
//class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UISearchBarDelegate {
//
//    @IBOutlet var theMap: MKMapView!
//    
//    var manager:CLLocationManager!
//    var locationManager : CLLocationManager!
//    @IBOutlet var searchBar: UISearchBar!
//    
//    var searchController:UISearchController!
//    var annotation:MKAnnotation!
//    var localSearchRequest:MKLocalSearchRequest!
//    var localSearch:MKLocalSearch!
//    var localSearchResponse:MKLocalSearchResponse!
//    var error:NSError!
//    var pointAnnotation:MKPointAnnotation!
//    var pinAnnotationView:MKPinAnnotationView!
//    
//    override func viewDidLoad(){
//        super.viewDidLoad()
//        let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
//        centerMapOnLocation(initialLocation)
//        
//        theMap.showsUserLocation = true
//
//        locationManager = CLLocationManager()
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.startUpdatingLocation()
//        
//        theMap.delegate = self
//        theMap.mapType = MKMapType.Standard
//        theMap.showsUserLocation = true
//        
//        
//        let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 34.03, longitude: 118.14)
//        let span = MKCoordinateSpanMake(100, 80)
//        let region = MKCoordinateRegionMake(coordinate, span)
//        self.theMap.setRegion(region, animated: true)
//    }
//    
//    let regionRadius: CLLocationDistance = 1000
//    func centerMapOnLocation(location: CLLocation) {
//        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
//            regionRadius * 2.0, regionRadius * 2.0)
//        theMap.setRegion(coordinateRegion, animated: true)
//    }
//
//    
//    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
//        
//        if overlay is MKPolyline {
//            var polylineRenderer = MKPolylineRenderer(overlay: overlay)
//            polylineRenderer.strokeColor = UIColor.blueColor()
//            polylineRenderer.lineWidth = 4
//            return polylineRenderer
//        }
//        return nil
//    }
//    
//  
//    //when touch background, keyboard dismisses
//    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
//        searchBar.endEditing(true)
//        
//    }
//    
//    ////asdklfjaklsdfjlasf
//    func searchBarSearchButtonClicked(searchBar: UISearchBar){
//        //1
//        searchBar.resignFirstResponder()
//        dismissViewControllerAnimated(true, completion: nil)
//        if self.theMap.annotations.count != 0{
//            annotation = self.theMap.annotations[0] as! MKAnnotation
//            self.theMap.removeAnnotation(annotation)
//        }
//        //2
//        localSearchRequest = MKLocalSearchRequest()
//        localSearchRequest.naturalLanguageQuery = searchBar.text
//        localSearch = MKLocalSearch(request: localSearchRequest)
//        localSearch.startWithCompletionHandler { (localSearchResponse, error) -> Void in
//            
//            if localSearchResponse == nil{
//                var alert = UIAlertView(title: nil, message: "Place not found", delegate: self, cancelButtonTitle: "Try again")
//                alert.show()
//                return
//            }
//            //3
//            self.pointAnnotation = MKPointAnnotation()
//            self.pointAnnotation.title = searchBar.text
//            self.pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: localSearchResponse.boundingRegion.center.latitude, longitude:     localSearchResponse.boundingRegion.center.longitude)
//            
//            
//            self.pinAnnotationView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: nil)
//            self.theMap.centerCoordinate = self.pointAnnotation.coordinate
//            self.theMap.addAnnotation(self.pinAnnotationView.annotation)
//        }
//    }
//}
