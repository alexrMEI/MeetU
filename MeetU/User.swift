//
//  User.swift
//  MeetU
//
//  Created by Ricardo Miguel da Silva Rodrigues on 20/11/2019.
//  Copyright © 2019 MeetU Inc. All rights reserved.
//

import Foundation
import Firebase

class User: NSObject {
    //MARK: Properties
    @objc dynamic var name: String
    let email: String
    let id: String
    var profilePic: UIImage
    var latitude: String
    var longitude : String
    var favouriteUsers: [String]
    
    //MARK: Init
    init(name: String, email: String, id: String, profilePic: UIImage, latitude:String, longitude:String) {
        self.name = name
        self.email = email
        self.id = id
        self.profilePic = profilePic
        self.latitude = latitude
        self.longitude = longitude
        self.favouriteUsers = [String]()
        super.init()
    }
}
