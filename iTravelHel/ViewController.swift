//
//  ViewController.swift
//  iTravelHel
//
//  Created by Jukka-Pekka Seppänen on 10.12.2015.
//  Edited by Jukka-Pekka Seppänen & Arttu Ylhävuori
//  Copyright © 2015 XCode-Popup. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var mapView: MKMapView!

    var centerMode = false
    @IBAction func locateMe(sender: AnyObject) { // a functionality for clicking the locating button
        centerLocation()
        centerMode = true
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
        getStopsFromArea()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        if(centerMode){
            centerLocation()
             getStopsFromArea()
        }
    }

    @IBAction func mapClick(sender: AnyObject) { // recognizes if somebody taps the screen
        centerMode = false
    }
    
    func centerLocation(){
        let zoomLevel = locationManager.location!.horizontalAccuracy * 0.00010
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: zoomLevel, longitudeDelta: zoomLevel))
        self.mapView.setRegion(region, animated: true)
    }
    
    func getStopsFromArea(){ // adds nearby bus stops to the map
        // first locates the user by using latitude and longitude values:
        let latitude = self.locationManager.location!.coordinate.latitude
        let latitudeString = String(latitude)
        let longitude = self.locationManager.location!.coordinate.longitude
        let longitudeString = String(longitude)
        
        do {// searches data from HSL API by using php and JSON
            let contents = try String(contentsOfURL: NSURL(string: "http://outdoorathletics.fi/stopsinarea.php?x=" + longitudeString + "&y=" + latitudeString)!, usedEncoding: nil)
            let jsonData = convertStringToDictionary(contents)
            stopsOnMap(jsonData!)
        } catch {
            print("Contents could not be loaded")
        }
    }
    
    func convertStringToDictionary(text: String) -> [String:AnyObject]? {
        if let data = text.dataUsingEncoding(NSUTF8StringEncoding) {
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as? [String:AnyObject]
                //print(json!["stops"]!.count)
                return json
            } catch {
                print("JSON couldn't be parsed")
            }
        }
        return nil
    }
    func stopsOnMap(jsonData : [String:AnyObject]){
        
        for var index = 0; index < jsonData["stops"]!.count; ++index {
            let stop = jsonData["stops"]![index]["coords"]!
            var coorArray = stop!.componentsSeparatedByString(",")
            let longitudeString: Double = Double(coorArray [0])!
            let latitudeString: Double = Double(coorArray [1])!
            let stopLocation : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latitudeString, longitude: longitudeString)
            let annotation = MKPointAnnotation()
            annotation.coordinate = stopLocation
            annotation.title = String(jsonData["stops"]![index]["name"])
            annotation.subtitle = String(jsonData["stops"]![index]["address"])
            mapView.addAnnotation(annotation)
        }
    }
    // add bus numbers and driving times to bus stops
    
    func busInformation(){
        
    }
    
    // empty the map before downloading the new pins
    
    // add a thread where to update all the bus stop information in every 10 second (etc.)
    // http://stackoverflow.com/a/30841417
    
}

