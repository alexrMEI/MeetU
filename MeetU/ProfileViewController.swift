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
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userNameTextField.delegate = self
        userPasswordTextField.delegate = self
        
        user = UserDefaults.standard.value(forKey: "userDetails") as? User
        print(user?.email)
        
        //sharedUserController
        //profilePhoto = user?.profilePic
        //userNameTextField = user?.name
    }
    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        userNameTextField.resignFirstResponder()
        userPasswordTextField.resignFirstResponder()
        return true
    }
    
    //MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
    didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey :
    Any]) {
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage   else {
                fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
            }
        profilePhoto.image = selectedImage
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Actions
    @IBAction func selectImageFromLibrary2(_ sender: UITapGestureRecognizer) {
        // Hide the keyboard.
        print("HEYyyyyyy")
        userNameTextField.resignFirstResponder()
        userPasswordTextField.resignFirstResponder()
        let imagePickerController = UIImagePickerController() // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }

    @IBAction func save(_ sender: UIStoryboardSegue) {
        
    }
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            return
        }
        let name = userNameTextField.text ?? ""
        let password = userPasswordTextField.text ?? ""
        let photo = profilePhoto.image
        //user = User(name: name, email: password, photo: photo) //INCORRETO!!!!!!
    }
}
