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
import GeoFire

class MenuViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    var geoFireRef: DatabaseReference?
    var geoFire: GeoFire?
    var myQuery: GFQuery?
    let radius: Double = 100
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: Try to use UserController func
    func getUsersLocation() {
        // TO DO
        geoFireRef = Database.database().reference().child("Geolocs")
        
        geoFire = GeoFire(firebaseRef: geoFireRef!)
        
        // TO DO
        let userLat = UserDefaults.standard.value(forKey: "current_latitude") as! String
        let userLong = UserDefaults.standard.value(forKey: "current_longitude") as! String
        
        let location:CLLocation = CLLocation(latitude: CLLocationDegrees(Double(userLat)!), longitude: CLLocationDegrees(Double(userLong)!))
        
        myQuery = geoFire?.query(at: location, withRadius: self.radius)
        
        myQuery?.observe(.keyEntered, with: { (key, location) in
            
           // print("KEY:\(String(describing: key)) and location:\(String(describing: location))")
            
            //SwiftOverlays.showTextOverlay(self.view, text: "Searching for nearby users...")
            
            if key != Auth.auth().currentUser?.uid
            {
                let ref = Database.database().reference().child("Users").child(key)
                
                ref.observeSingleEvent(of: .value, with: { (snapshot) in
                    let id = snapshot.key
                    let data = snapshot.value as! [String: Any]
                    if !(data["favouriteUsers"] is [String]) {
                        let credentials = data as! [String: String]
                        
                        let name = credentials["name"]!
                        let email = credentials["email"]!
                        let latitude = credentials["current_latitude"] ?? "0"
                        let longitude = credentials["current_longitude"] ?? "0"
                        let link = credentials["profilepic"] ?? ""


                        DispatchQueue.main.async {
                            self.ShowNearbyUsers(Double(latitude)!, Double(longitude)!, name)
                        }
                    }
                    
                })
            }
            else
            {
                DispatchQueue.main.async {
                    //SwiftOverlays.removeAllBlockingOverlays()
                }
            }
        })
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
            
            /*UserController.info(forUserID: "asdad", completion: {(user) in
                
            })*/
            
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

    extension MenuViewController: CLLocationManagerDelegate, MKMapViewDelegate {
        // called when the authorization status is changed for the core location permission
        func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            print("location manager authorization status changed")
            
            if (status == .authorizedWhenInUse || status == .authorizedAlways){
                //manager.requestLocation()
                manager.startUpdatingLocation()
            }
        }
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            // .requestLocation will only pass one location to the locations array
            // hence we can access it by taking the first element of the array
            
            let updatedLocation:CLLocation = locations.first!
            
            let newCoordinate: CLLocationCoordinate2D = updatedLocation.coordinate
            
            let usrDefaults:UserDefaults = UserDefaults.standard
            
            usrDefaults.set("\(newCoordinate.latitude)", forKey: "current_latitude")
            usrDefaults.set("\(newCoordinate.longitude)", forKey: "current_longitude")
            usrDefaults.synchronize()
            
            userAuthLocation()
            
            if let location = locations.first {
                let allAnnotations = self.mapView.annotations
                self.mapView.removeAnnotations(allAnnotations)
                print("\(location.coordinate.latitude)")
                print("\(location.coordinate.longitude)")
                
                //Map Kit
                let location = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                
                let span = MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003)
                
                let region = MKCoordinateRegion(center: location, span: span)
                
                mapView.setRegion(region, animated: true)
                
                let annotation = MKPointAnnotation()
                
                annotation.coordinate = location
                
                annotation.title = "You"
                
                annotation.subtitle = "Your Name"
                    
                mapView.addAnnotation(annotation)
                
                self.addRadiusCircle(location: CLLocation(latitude: location.latitude, longitude: location.longitude))
                
                var ref: DatabaseReference!
                ref = Database.database().reference()
                // TODO - colocar user.uid dinamico
                //ref.child("Users").child("XiEGVhTdMdMklM5OAfHIrNXSZj93").child("Location").setValue(["Latitude": location.latitude, "Longitude": location.longitude])
            }
        }
        
        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            // might be that user didn't enable location service on the device
            // or there might be no GPS signal inside a building
         
            // might be a good idea to show an alert to user to ask them to walk to a place with GPS signal
            print("Location Error:\(error.localizedDescription)")
        }
        
        func userAuthLocation () {
            geoFireRef = Database.database().reference().child("Geolocs")
            
            geoFire = GeoFire(firebaseRef: geoFireRef!)
            
            let userLat = UserDefaults.standard.value(forKey: "current_latitude") as! String
            let userLong = UserDefaults.standard.value(forKey: "current_longitude") as! String
            
            let ref = Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid)
            ref.updateChildValues(["current_latitude": userLat, "current_longitude": userLong])
            
            print(Auth.auth().currentUser!.uid)

            let location:CLLocation = CLLocation(latitude: CLLocationDegrees(Double(userLat)!), longitude: CLLocationDegrees(Double(userLong)!))
            self.geoFire?.setLocation(location, forKey:Auth.auth().currentUser!.uid)
            
            getUsersLocation()
        }
        
        func ShowNearbyUsers(_ latitude: Double, _ longitude: Double, _ name: String) {
            //Map Kit
            let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            
            let annotation = MKPointAnnotation()
            
            annotation.coordinate = location
            
            annotation.title = name
                
            mapView.addAnnotation(annotation)
        }
        
        func addRadiusCircle(location: CLLocation){
            for ov in mapView.overlays {
                mapView.removeOverlay(ov)
            }
            self.mapView.delegate = self
            let circle = MKCircle(center: location.coordinate, radius: self.radius)
            self.mapView.addOverlay(circle)
            
        }

        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if overlay is MKCircle {
                let circle = MKCircleRenderer(overlay: overlay)
                circle.strokeColor = UIColor.blue
                circle.fillColor = UIColor(red: 0, green: 0, blue: 255, alpha: 0.1)
                circle.lineWidth = 1
                return circle
            } else {
                return MKPolylineRenderer()
            }
        }
        
        override func viewWillAppear(_ animated: Bool) {
            self.navigationItem.setHidesBackButton(true, animated: true)
            
            if UserController.shared.darkMode {
                overrideUserInterfaceStyle = .dark
            } else {
                overrideUserInterfaceStyle = .light
            }
            
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
            locationManager.delegate = self
            
            retriveCurrentLocation()
        }
}
