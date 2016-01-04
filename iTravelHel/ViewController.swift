//
//  ViewController.swift
//  iTravelHel
//
//  Created by Jukka-Pekka Seppänen on 10.12.2015.
//  Copyright © 2015 XCode-Popup. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var mapView: MKMapView!

    var centerMode = -1
    @IBAction func locateMe(sender: AnyObject) { // a functionality for clicking the locating button
        centerLocation()
        centerMode++
        if(centerMode > 1){
            centerMode = -1;
        }
    }
    
    var center = CLLocationCoordinate2D()

    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.mapView.showsUserLocation = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        if(centerMode == 1){
            centerLocation()
        }
    }

    @IBAction func mapClick(sender: AnyObject) { // recognizes if somebody taps the screen
        centerMode = -1
    }
    
    func centerLocation(){
        let zoomLevel = locationManager.location!.horizontalAccuracy * 0.00010
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: zoomLevel, longitudeDelta: zoomLevel))
        self.mapView.setRegion(region, animated: true)
    }
    
    func busStops(){
        // 1. must know the current location with coordinates
        var currentLocation = self.locationManager.location
        var currentLocationString = String(currentLocation)
        
        // 2. make a HTTP request to HSL API (notice that Map Kit uses a Mercator map protection)
        let url = NSURL(string: "http://api.reittiopas.fi/hsl/prod/?request=stops_area&user=reittiapiconnection&pass=reittiaplikaatio&format=txt&center_coordinate="+currentLocationString+"&limit=20&diameter=1500&epsg_in=mercator&epsg_out=mercator")
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!){(data, response, error) in println(NSString(data: data, encoding: NSUTF8StringEncoding))}
            task.resume()
        
        // 3. set the nearby bus stops to the map with pins

    }
}

