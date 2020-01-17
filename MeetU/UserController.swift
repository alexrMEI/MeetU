//
//  UserController.swift
//  MeetU
//
//  Created by Ricardo Miguel da Silva Rodrigues on 06/12/2019.
//  Copyright © 2019 MeetU Inc. All rights reserved.
//

import Foundation
import Firebase
import GeoFire
import os.log

class UserController {
    var items = [User]()
    
    static let shared = UserController()
    
    init(){}
    
    var geoFireRef: DatabaseReference?
    var geoFire: GeoFire?
    var myQuery: GFQuery?
    
    //MARK: Register User
    class func registerUser(withName: String, email: String, password: String, completion: @escaping (String) -> Swift.Void) {
        Auth.auth().createUser(withEmail: email, password: password, completion: { (authResult, error) in
            
            if error == nil {
                //let values = ["Name": withName, "Email": email]
                let values = ["name": withName, "email": email, "profilepic_url": "","current_latitude":"","current_longitude":""]
                Database.database().reference().child("Users").child((authResult?.user.uid)!).updateChildValues(values, withCompletionBlock: { (errr, _) in
                    if errr == nil {
                        let userInfo = ["email" : email, "password" : password]
                        UserDefaults.standard.set(userInfo, forKey: "userDetails")
                        completion("")
                    }
                })
            }
            else {
                print(error ?? "Erro")
                let err = error! as NSError
                switch err.code {
                case AuthErrorCode.wrongPassword.rawValue:
                   print("wrong password")
                    completion("Wrong password")
                case AuthErrorCode.weakPassword.rawValue:
                    print("at least 6")
                    //self.showToast(controller: self, message: "Password must have at least 6 characters", seconds: 1.5)
                    completion("Password must have at least 6 characters")
                case AuthErrorCode.invalidEmail.rawValue:
                   print("invalid email")
                   //self.showToast(controller: self, message: "Invalid email", seconds: 1.5)
                    completion("Invalid email")
                case AuthErrorCode.accountExistsWithDifferentCredential.rawValue:
                   print("accountExistsWithDifferentCredential")
                    //completion("Password must have at least 6 characters")
                case AuthErrorCode.emailAlreadyInUse.rawValue: //<- Your Error
                   print("email is alreay in use")
                   //self.showToast(controller: self, message: "This email already exists", seconds: 1.5)
                    completion("This email already exists")
                default:
                   print("unknown error: \(err.localizedDescription)")
                    //completion("Password must have at least 6 characters")
                }
                
                //completion(false)
            }
        })
    }
    
    //MARK: Login User
    class func loginUser(withEmail: String, password: String, completion: @escaping (Bool) -> Swift.Void) {
        Auth.auth().signIn(withEmail: withEmail, password: password, completion: { (user, error) in
            if error == nil {
                let userInfo = ["email": withEmail, "password": password]
                UserDefaults.standard.set(userInfo, forKey: "userDetails")
                completion(true)
            } else {
                completion(false)
            }
        })
    }
    
    //MARK: Logout User
    class func logOutUser(completion: @escaping (Bool) -> Swift.Void) {
        do {
            try Auth.auth().signOut()
            UserDefaults.standard.removeObject(forKey: "userDetails")
            completion(true)
        } catch _ {
            completion(false)
        }
    }
    
    //MARK: User Info
    class func info(forUserID: String, completion: @escaping (User) -> Swift.Void) {
        Database.database().reference().child("Users").child(forUserID).observeSingleEvent(of: .value, with: { (snapshot) in
            if let data = snapshot.value as? [String: String] {
                let name = data["name"]!
                let email = data["email"]!
                let link = URL.init(string: data["profilepic_url"]!)
                let latitude = data["current_latitude"]
                let longitude = data["current_longitude"]
                
                URLSession.shared.dataTask(with: link!, completionHandler: { (data, response, error) in
                    if error == nil {
                        let profilePic = UIImage.init(data: data!)
                        let user = User.init(name: name, email: email, id: forUserID, profilePic: profilePic!, latitude: latitude! , longitude:longitude!)
                        completion(user)
                    }
                }).resume()
            }
        })
    }
    
    //MARK: Download all Users
    class func downloadAllUsers(exceptID: String, completion: @escaping (User) -> Swift.Void) {
        Database.database().reference().child("Users").observe(.childAdded, with: { (snapshot) in
            let id = snapshot.key
            let data = snapshot.value as! [String: Any]
            let credentials = data["user_details"] as! [String: String]
            if id != exceptID {
                let name = credentials["name"]!
                let email = credentials["email"]!
                let latitude = credentials["Latitude"]
                let longitude = credentials["Longitude"]
                let link = URL.init(string: credentials["ProfilePic"]!)
                URLSession.shared.dataTask(with: link!, completionHandler: { (data, response, error) in
                    if error == nil {
                        let profilePic = UIImage.init(data: data!)
                        let user = User.init(name: name, email: email, id: id, profilePic: profilePic!, latitude: latitude! , longitude:longitude! )
                        completion(user)
                    }
                }).resume()
            }
        })
    }
    
    // MARK: Get Users
    func getUsers()  {

        //SwiftOverlays.showTextOverlay(self.view, text: "Searching users...")
        
        if let id = Auth.auth().currentUser?.uid {
            UserController.downloadAllUsers(exceptID: id, completion: {(user) in
                
                DispatchQueue.main.async {
                    //SwiftOverlays.removeAllBlockingOverlays()
                    self.items.append(user)
                }
            })
        }
    }
    
    // MARK: Get Users Location
    func GetUsersLocation(completion: @escaping (User) -> Swift.Void) {
        // TO DO
        geoFireRef = Database.database().reference().child("Geolocs")
        
        geoFire = GeoFire(firebaseRef: geoFireRef!)
        
        // TO DO
        let userLat = UserDefaults.standard.value(forKey: "current_latitude") as! String
        let userLong = UserDefaults.standard.value(forKey: "current_longitude") as! String
        
        let location:CLLocation = CLLocation(latitude: CLLocationDegrees(Double(userLat)!), longitude: CLLocationDegrees(Double(userLong)!))
        
        myQuery = geoFire?.query(at: location, withRadius: 100)
        
        myQuery?.observe(.keyEntered, with: { (key, location) in
            
           // print("KEY:\(String(describing: key)) and location:\(String(describing: location))")
            
            //SwiftOverlays.showTextOverlay(self.view, text: "Searching for nearby users...")
            
            if key != Auth.auth().currentUser?.uid
            {
                let ref = Database.database().reference().child("Users").child(key)
                
                ref.observeSingleEvent(of: .value, with: { (snapshot) in
                    let id = snapshot.key
                    let data = snapshot.value as! [String: Any]
                    //let credentials = data["user_details"] as! [String: String]
                    let credentials = data as! [String: String]
                    
                    let name = credentials["name"]!
                    let email = credentials["email"]!
                    let latitude = credentials["current_latitude"] ?? "0"
                    let longitude = credentials["current_longitude"] ?? "0"
                    //let link = URL.init(string: credentials["profilepic_url"]!)
                    guard let url = URL(string: "https://www.google.com/url?sa=i&url=https%3A%2F%2Fipc.digital%2Ficon-user-default%2F&psig=AOvVaw0jQrpOXTD5ycDKfr7FGioR&ust=1576412225151000&source=images&cd=vfe&ved=0CAIQjRxqFwoTCKjriamPteYCFQAAAAAdAAAAABAD") else {
                        os_log("Invalid URL.", log: OSLog.default, type: .error)
                        return
                    }
                    
                    URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                        if error == nil {
                            
                            //var profilePic :UIImage
                            
                            //let url = URL(string: "https://cdn.arstechnica.net/wp-content/uploads/2018/06/macOS-Mojave-Dynamic-Wallpaper-transition.jpg")!
                            //var profilePic: UIImage// = self.downloadImage(from: url)
                            
                            
                            let profilePic :UIImage = UIImage()
                            
                            //let profilePic = UIImage.init(data: data!)
                            let user = User.init(name: name, email: email, id: id, profilePic: profilePic, latitude: latitude , longitude:longitude )
                            
                            DispatchQueue.main.async {
                                //SwiftOverlays.removeAllBlockingOverlays()
                                self.items.append(user)
                                completion(user)
                                //self.tblUserList.reloadData()
                            }
                            
                        }
                    }).resume()
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

    // MARK: Show Toast if fields are empty
    /*func showToast(controller: UIViewController, message : String, seconds: Double) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.view.backgroundColor = .black
        alert.view.alpha = 0.5
        alert.view.layer.cornerRadius = 15
        
        controller.present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            alert.dismiss(animated: true)
        }
    }*/
} 
