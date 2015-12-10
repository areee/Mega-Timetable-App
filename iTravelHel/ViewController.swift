//
//  ViewController.swift
//  iTravelHel
//
//  Created by Jukka-Pekka Seppänen on 8.12.2015.
//  Copyright © 2015 XCode-Popup. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    var center = CLLocationCoordinate2D()
    

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

    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError){
        print("Errors: " + error.localizedDescription)
    }
    
    func centerMap(){
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
        self.mapView.setRegion(region, animated: true)
        locationManager.stopUpdatingLocation()
    }
}
