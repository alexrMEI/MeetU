//
//  ProfileViewController.swift
//  MeetU
//
//  Created by Filipa Reis da Fonte on 06/12/2019.
//  Copyright © 2019 MeetU Inc. All rights reserved.
//

import Foundation
import UIKit

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var profilePhoto: UIImageView!
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let user = user {
            profilePhoto.image = user.photo
            profilePhoto.isUserInteractionEnabled = false
        }
    }
    
    //MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
    didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey :
    Any]) {
    // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage   else {
                fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
            }
        profilePhoto.image = selectedImage
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
}
