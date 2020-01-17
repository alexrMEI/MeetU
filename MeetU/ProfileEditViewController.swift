//
//  ProfileEditViewController.swift
//  MeetU
//
//  Created by Alexandre dos Santos Rodrigues on 17/01/2020.
//  Copyright © 2020 MeetU Inc. All rights reserved.
//

import UIKit

class ProfileEditViewController: UIViewController {
    
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var editedName: UITextField!
    @IBOutlet weak var editedPassword: UITextField!
    
    var user: User?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        user = User.init(name: "asd", email: "asd@asd.com", id: "123asd", latitude: "12-223", longitude: "123123-123123")
        
        print("ASDASD \(user)")
    }
    
    
    @IBAction func editName(_ sender: Any) {
    }
    
    @IBAction func editPassword(_ sender: Any) {
    }

    @IBAction func cancelAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)

        dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
