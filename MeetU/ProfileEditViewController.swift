//
//  ProfileEditViewController.swift
//  MeetU
//
//  Created by Alexandre dos Santos Rodrigues on 17/01/2020.
//  Copyright © 2020 MeetU Inc. All rights reserved.
//

import UIKit
import Firebase

class ProfileEditViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var editedName: UITextField!
    @IBOutlet weak var editedPassword: UITextField!
    @IBOutlet weak var editedEmail: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var user: User!
    var profilePicDecoded: UIImage!
    var profilePicOldBase64: String!
    var imagePicker = UIImagePickerController()
    var selectedImageBase64: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        editedName.text = user.name
        editedEmail.text = user.email
        profilePhoto.image = profilePicDecoded
        profilePicOldBase64 = user.profilePic
    }
        
    @IBAction func saveUser(_ sender: Any) {
   
        selectedImageBase64 = base64Encode(profilePhoto: profilePhoto.image)
        if(profilePicOldBase64.elementsEqual(selectedImageBase64) == false) {
            Database.database().reference().child("Users/\(self.user!.id)/profilepic_url").setValue(selectedImageBase64)
        }
        
        if(editedName.text!.elementsEqual(self.user.name) == false) {
            Database.database().reference().child("Users/\(self.user!.id)/name").setValue(editedName.text)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            return
        }
        //let name = userNameTextField.text ?? ""
        //let password = userPasswordTextField.text ?? ""
        //let photo = profilePhoto.image */
        //user = User(name: name, email: password, photo: photo) //INCORRETO!!!!!!
    }
    
    func base64Encode(profilePhoto: UIImage?) -> String{
        var profilePhotoData: Data = (profilePhoto?.pngData())!
        var profilePhotoNewBase64: String = profilePhotoData.base64EncodedString()
        profilePhotoNewBase64 = "data:image/png;base64,\(profilePhotoNewBase64)"
        return profilePhotoNewBase64
    }
    
    @IBAction func editName(_ sender: Any) {
    }
    
    @IBAction func editPassword(_ sender: Any) {
    }

    @IBAction func cancelAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)

        dismiss(animated: true, completion: nil)
    }
    
    //MARK: UIImagePickerController
    @IBAction func selectImage(_ sender: UITapGestureRecognizer) {
        editedName.resignFirstResponder()
        editedPassword.resignFirstResponder()
        editedEmail.resignFirstResponder()
        
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))

        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallery()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))

        self.present(alert, animated: true, completion: nil)
    }

    func openCamera() {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

    func openGallery() {
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
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
}
