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
import SwiftOverlays
import os.log

class NearbyUserListTableViewController: UITableViewController {
    var users = [User]()
    var group = DispatchGroup()
    
    var geoFireRef: DatabaseReference?
    var geoFire: GeoFire?
    var myQuery: GFQuery?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        group.enter()
        UserController.shared.GetUsersLocation(group: group, completion: {(user) in
            if let superview = self.view.superview {
                SwiftOverlays.showCenteredWaitOverlayWithText(superview, text: "Searching for nearby users...")
            }
            self.users.append(user)
            self.group.leave()
        })
        
        group.notify(queue: .main) {
            self.tableView.reloadData()
            
            if let superview = self.view.superview {
                SwiftOverlays.removeAllOverlaysFromView(superview)
            }
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
        
        cell.name.text = user.name
        cell.user = user
                
        UserController.shared.getFavouriteUsers(completion: {(usersId) in
            for u in usersId {
                if (user.id == u) {
                    cell.FavouriteControl.rating = 1
                }
            }
        })

        /*cell.photoImageView.image = meal.photo
        cell.ratingControl.rating = meal.rating*/
                
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(identifier: "ChatVC") as? ChatViewController
        let user = users[indexPath.row]
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


