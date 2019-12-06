//
//  MenuViewController.swift
//  MeetU
//
//  Created by Alexandre dos Santos Rodrigues on 21/11/2019.
//  Copyright © 2019 MeetU Inc. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Firebase
import FirebaseDatabase

class MenuViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        //if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            //locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            //locationManager.startUpdatingLocation()
        //}
        
        retriveCurrentLocation()
    }
    
    func retriveCurrentLocation(){
        let status = CLLocationManager.authorizationStatus()
        
        if(status == .denied || status == .restricted || !CLLocationManager.locationServicesEnabled()){
            // show alert to user telling them they need to allow location data to use some feature of your app
            return
        }
        
        // if haven't show location permission dialog before, show it to user
        if(status == .notDetermined){
            locationManager.requestWhenInUseAuthorization()
            
            // if you want the app to retrieve location data even in background, use requestAlwaysAuthorization
            // locationManager.requestAlwaysAuthorization()
            return
        }
        
        UserController.info(forUserID: "asdad", completion: {(user) in
            
        })
        
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        
        // at this point the authorization status is authorized
        // request location data once
        locationManager.requestLocation()
        
        // start monitoring location data and get notified whenever there is change in location data / every few seconds, until stopUpdatingLocation() is called
        // locationManager.startUpdatingLocation()
    }

    /*func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        
        
    }*/
}

extension MenuViewController: CLLocationManagerDelegate{
    // called when the authorization status is changed for the core location permission
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("location manager authorization status changed")
        
        if (status == .authorizedWhenInUse || status == .authorizedAlways){
            manager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // .requestLocation will only pass one location to the locations array
        // hence we can access it by taking the first element of the array
        if let location = locations.first {
            print("\(location.coordinate.latitude)")
            print("\(location.coordinate.longitude)")
            
            //Map Kit
            let location = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            
            let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
            
            let region = MKCoordinateRegion(center: location, span: span)
            
            mapView.setRegion(region, animated: true)
            
            let annotation = MKPointAnnotation()
            
            annotation.coordinate = location
            
            annotation.title = "You"
            
            annotation.subtitle = "Your Name"
                
            mapView.addAnnotation(annotation)
            
            var ref: DatabaseReference!
            ref = Database.database().reference()
            // TODO - colocar user.uid dinamico
            ref.child("Users").child("XiEGVhTdMdMklM5OAfHIrNXSZj93").child("Location").setValue(["Latitude": location.latitude, "Longitude": location.longitude])
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // might be that user didn't enable location service on the device
        // or there might be no GPS signal inside a building
     
        // might be a good idea to show an alert to user to ask them to walk to a place with GPS signal
    }
}
