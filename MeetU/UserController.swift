//
//  UserController.swift
//  MeetU
//
//  Created by Ricardo Miguel da Silva Rodrigues on 06/12/2019.
//  Copyright © 2019 MeetU Inc. All rights reserved.
//

import Foundation
import Firebase

class UserController {
    
    //MARK: Register User
    class func registerUser(withName: String, email: String, password: String, completion: @escaping (Bool) -> Swift.Void) {
        Auth.auth().createUser(withEmail: email, password: password, completion: { (authResult, error) in
            
            if error == nil {
                let values = ["Name": withName, "Email": email]
                Database.database().reference().child("Users").child((authResult?.user.uid)!).updateChildValues(values, withCompletionBlock: { (errr, _) in
                    if errr == nil {
                        let userInfo = ["email" : email, "password" : password]
                        UserDefaults.standard.set(userInfo, forKey: "userDetails")
                        completion(true)
                    }
                })
            }
            else {
                print(error ?? "Erro")
                let err = error! as NSError
                switch err.code {
                case AuthErrorCode.wrongPassword.rawValue:
                   print("wrong password")
                case AuthErrorCode.weakPassword.rawValue:
                    print("at least 6")
                    self.showToast(controller: self, message: "Password must have at least 6 characters", seconds: 1.5)
                case AuthErrorCode.invalidEmail.rawValue:
                   print("invalid email")
                    self.showToast(controller: self, message: "Invalid email", seconds: 1.5)
                case AuthErrorCode.accountExistsWithDifferentCredential.rawValue:
                   print("accountExistsWithDifferentCredential")
                case AuthErrorCode.emailAlreadyInUse.rawValue: //<- Your Error
                   print("email is alreay in use")
                    self.showToast(controller: self, message: "This email already exists", seconds: 1.5)
                default:
                   print("unknown error: \(err.localizedDescription)")
                }
                
                completion(false)
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
                let name = data["Name"]!
                let email = data["Email"]!
                let link = URL.init(string: data["ProfilePic"]!)
                let latitude = data["Latitude"]
                let longitude = data["Longitude"]
                
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
    
    // MARK: Show Toast if fields are empty
    func showToast(controller: UIViewController, message : String, seconds: Double) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.view.backgroundColor = .black
        alert.view.alpha = 0.5
        alert.view.layer.cornerRadius = 15
        
        controller.present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            alert.dismiss(animated: true)
        }
    }
}
