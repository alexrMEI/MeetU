//
//  ProfileViewController.swift
//  MeetU
//
//  Created by Filipa Reis da Fonte on 06/12/2019.
//  Copyright © 2019 MeetU Inc. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class ProfileViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: Properties
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    let group = DispatchGroup()
    let userUID = Auth.auth().currentUser?.uid
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        group.enter()
        Database.database().reference().child("Users").child(userUID!).observeSingleEvent(of: .value, with: {(snapshot) in
            self.user = User.init(user: snapshot.value as! Dictionary<String, String>, id: self.userUID!)
            self.group.leave()
        })
        
        group.notify(queue: .main){
            self.emailLabel.text = self.user?.email
            self.nameLabel.text = self.user?.name
            self.profilePhoto.image = self.base64Decode(base64String: self.user?.profilePic)
        }
    }
    
    //MARK: UITextFieldDelegate
    /* func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        userNameTextField.resignFirstResponder()
        userPasswordTextField.resignFirstResponder()
        return true
    } */
    
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "editSegue") {
            if let viewController = segue.destination as? ProfileEditViewController {
              if(user != nil){
                viewController.user = user!
                viewController.profilePicDecoded = profilePhoto.image!
               }
            }
        }
        
        /* super.prepare(for: segue, sender: sender)
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            return
        }
        let name = userNameTextField.text ?? ""
        let password = userPasswordTextField.text ?? ""
        let photo = profilePhoto.image */
        //user = User(name: name, email: password, photo: photo) //INCORRETO!!!!!!
    }
    
    func base64Decode(base64String: String?) -> UIImage{
      if (base64String?.isEmpty)! {
          return #imageLiteral(resourceName: "user_icon")
      }else {
          let temp = base64String?.components(separatedBy: ",")
          let dataDecoded : Data = Data(base64Encoded: temp![1], options: .ignoreUnknownCharacters)!
          let decodedImage = UIImage(data: dataDecoded)
          return decodedImage!
      }
    }
}
