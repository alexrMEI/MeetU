//
//  User.swift
//  MeetU
//
//  Created by Ricardo Miguel da Silva Rodrigues on 20/11/2019.
//  Copyright © 2019 MeetU Inc. All rights reserved.
//

import UIKit
import os.log
import Foundation
import Firebase

class User: NSObject  {
    //MARK: Properties
    @objc dynamic var name: String
    let email: String
    let id: String
    var profilePic: String?
    var latitude: String?
    var longitude : String?
    var favouriteUsers: [String]

    //MARK: Init
    init(name: String, email: String, id: String, profilePic: String, latitude:String, longitude:String) {
        self.name = name
        self.email = email
        self.id = id
        self.profilePic = profilePic
        self.latitude = latitude
        self.longitude = longitude
        self.favouriteUsers = [String]()
    }

    init(user: Dictionary<String, String>, id: String) {
        self.name = user["name"]!
        self.email = user["email"]!
        self.profilePic = user["profilepic"]!
        self.id = id
        self.favouriteUsers = [String]()
    }
}
