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
        }
        getStopsFromArea(locations.last)
    }

    @IBAction func mapClick(sender: AnyObject) { // recognizes if somebody taps the screen
        centerMode = false
    }
    
    func centerLocation(){
        let zoomLevel = locationManager.location!.horizontalAccuracy * 0.00010
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: zoomLevel, longitudeDelta: zoomLevel))
        self.mapView.setRegion(region, animated: true)
    }
    
    func getStopsFromArea(location: CLLocationCoordinate2D){
        
        let currentLocation = self.locationManager.location
        let currentLocationString = String(currentLocation)
        
        /* 2. make a HTTP request to HSL API (notice that Map Kit uses a Mercator map protection)
        let url = NSURL(string: "http://api.reittiopas.fi/hsl/prod/?request=stops_area&user=reittiapiconnection&pass=reittiaplikaatio&format=txt&center_coordinate="+currentLocationString+"&limit=20&diameter=1500&epsg_in=mercator&epsg_out=mercator") */
        
        do {
            let contents = try String(contentsOfURL: NSURL(string: "http://outdoorathletics.fi/stopsinarea.php?" + currentLocationString)!, usedEncoding: nil)
            let jsonData = convertStringToDictionary(contents)
            getStopCoordinates(jsonData!)
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
        
        let newYorkLocation = CLLocationCoordinate2DMake(40.730872, -74.003066)
        // Drop a pin
        let dropPin = MKPointAnnotation()
        dropPin.coordinate = newYorkLocation
        dropPin.title = "Pysäkki"
        dropPin.subtitle = "Busseja"
        mapView.addAnnotation(dropPin)
        
        
        // print(jsonData)
    }
    
    func getStopCoordinates(jsonData : [String:AnyObject]!){
        for var index = 0; index < jsonData["stops"]!.count; ++index {
            let code = jsonData["stops"]![index]["code"]!
            print(code!)
        }
    }
}

