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

class User: NSObject, NSCoding {
    
    //MARK: Properties
    let name: String
    let email: String
    let id: String
    var profilePic: UIImage
    var latitude: String
    var longitude : String

    //MARK: Init
    init?(name: String, email: String, id: String, profilePic: UIImage?, latitude:String, longitude:String) {
        if name.isEmpty || email.isEmpty {
            return nil
        }
        self.name = name
        self.email = email
        self.id = id
        self.profilePic = profilePic
        self.latitude = latitude
        self.longitude = longitude
    }

    /*func encode(with coder: NSCoder) {
        coder.encode(name, forKey: PropertyKey.name)
        coder.encode(profilePic, forKey: PropertyKey.profilePic)
        coder.encode(email, forKey: PropertyKey.email)
    }

    required convenience init?(coder: NSCoder) {
        guard let name = coder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a User object.", log: OSLog.default, type: .debug)
            return nil
        }
        guard let email = coder.decodeObject(forKey: PropertyKey.email) as? String else {
            os_log("Unable to decode the email for a User object.", log: OSLog.default, type: .debug)
            return nil
        }
        let photo = coder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        self.init(name: name, email: email, photo: photo)
    }*/
}
