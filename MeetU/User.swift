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

class User {
    //MARK: Properties
    let name: String
    let email: String
    let id: String
    var profilePic: UIImage
    var latitude: String
    var longitude : String

    //MARK: Init
    init(name: String, email: String, id: String, profilePic: UIImage?, latitude:String, longitude:String) {
        self.name = name
        self.email = email
        self.id = id
        self.profilePic = (profilePic ?? nil)!
        self.latitude = latitude
        self.longitude = longitude
    }
}
