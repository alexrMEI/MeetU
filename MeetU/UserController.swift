//
//  UserController.swift
//  MeetU
//
//  Created by Filipa Reis da Fonte on 06/12/2019.
//  Copyright © 2019 MeetU Inc. All rights reserved.
//

import Foundation
import Firebase
import UIKit


class UserController {
    
    var name: String
    var email: String
    
    init(name: String, email: String) {
        self.name = name
        self.email = email
    }
    
    func updateUser(name: String, email:String, password: String, completion: @escaping (String)-> Swift.Void) {
        
        
        /*User user = Auth.auth().currentUser
        Auth.auth().updateCurrentUser(user) { (Error?) in
            
        }
        
        Auth.auth().updateCurrentUser(user, completion: {authre})*/
    }
    
}
