//
//  NearbyUserListTableViewController.swift
//  MeetU
//
//  Created by Alexandre dos Santos Rodrigues on 14/01/2020.
//  Copyright © 2020 MeetU Inc. All rights reserved.
//

import UIKit
import Firebase
import GeoFire
import os.log

class NearbyUserListTableViewController: UITableViewController {
    var users = [User]()
    var group = DispatchGroup()
    
    var geoFireRef: DatabaseReference?
    var geoFire: GeoFire?
    var myQuery: GFQuery?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ---------- TODO --------------
        group.enter()
        
        UserController.shared.GetUsersLocation(group: group, completion: {(user) in
            
            self.users.append(user)
            self.group.leave()
        })
        
        group.notify(queue: .main) {
            self.tableView.reloadData()
        }
        //self.users.append(User(name: "Ola1", email: "ola1@g.com", id: "1", profilePic: UIImage(), latitude: "", longitude: ""))
        //self.users.append(User(name: "Ola2", email: "ola2@g.com", id: "2", profilePic: UIImage(), latitude: "", longitude: ""))
        //self.users.append(User(name: "Ola3", email: "ola3@g.com", id: "3", profilePic: UIImage(), latitude: "", longitude: ""))

        //print("sai")
        
        //self.users = UserController.shared.GetUsersLocation()
        
        /*guard let user1 =
        guard let meal1 = Meal(name: "Caprese Salad", photo: photo1, rating: 4) else {
            fatalError("Unable to instantiate meal1") }
        guard let meal2 = Meal(name: "Chicken and Potatoes", photo: photo2, rating: 5) else {
            fatalError("Unable to instantiate meal2") }
        guard let meal3 = Meal(name: "Pasta with Meatballs", photo: photo3, rating: 3) else {
            fatalError("Unable to instantiate meal3") }
        meals += [meal1, meal2, meal3]*/

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // MARK: Get Users Location
    func GetUsersLocation() {
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
                                //self.items.append(user)
                                //self.group.leave()
                                //completion(user)
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

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.users.count
        //return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "NearbyUserTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? NearbyUserTableViewCell else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        
        // Fetches the appropriate meal for the data source layout.
        let user = users[indexPath.row]
        
        //cell.name.text = "hello"
        cell.name.text = user.name
        /*cell.photoImageView.image = meal.photo
        cell.ratingControl.rating = meal.rating*/
        
        cell.FavouriteControl.tag = indexPath.row
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(identifier: "ChatVC") as? ChatViewController
        let user = users[indexPath.row]
        print("BRL \(user.name) \(user.id)")
        vc?.user2Name = user.name
        vc?.user2UID = user.id
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func didLoadObject(for cell: NearbyUserTableViewCell){
        if let indexPath = tableView.indexPath(for: cell){
            tableView.reloadRows(at: [indexPath], with: .fade)
        }
    }

}


