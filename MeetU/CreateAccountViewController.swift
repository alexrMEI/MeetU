//
//  CreateAccountViewController.swift
//  MeetU
//
//  Created by Ricardo Miguel da Silva Rodrigues on 20/11/2019.
//  Copyright © 2019 MeetU Inc. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import SwiftOverlays
import AudioToolbox

class CreateAccountViewController: UIViewController {

    var ref: DatabaseReference! = Database.database().reference()
        
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var errorMessage: UILabel!
    
    private var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: Create new account when clicked
    @IBAction func onClickCreateAccount(_ sender: Any) {
        let name = usernameTxt.text
        let email = emailTxt.text
        let password = passwordTxt.text
        if(name?.isEmpty == true || email?.isEmpty == true || password?.isEmpty == true) {
            errorMessage.text = "Please fill all the fields"
            errorMessage.isHidden = false
            // Vibrate when error occurred
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        } else {
            
            if let superview = self.view.superview {
                SwiftOverlays.showCenteredWaitOverlayWithText(superview, text: "Signing up...")
            }
             
            UserController.registerUser(withName: name!, email: email!, password: password!) { [weak weakSelf = self] (status) in
                DispatchQueue.main.async {
                    if let superview = self.view.superview {
                        SwiftOverlays.removeAllOverlaysFromView(superview)
                    }
                    
                    if status == ""
                    {
                       // open the new page if creation is successful
                       let storyboard = UIStoryboard(name: "Main", bundle: nil)
                       let secondVC = storyboard.instantiateViewController(identifier: "TabBarController")
                       
                       secondVC.modalPresentationStyle = .fullScreen
                       secondVC.modalTransitionStyle = .crossDissolve
                       
                       self.present(secondVC, animated: true, completion: nil)
                    } else {
                        
                        //self.showToast(controller: self, message: status, seconds: 1.5)
                        self.errorMessage.text = status
                        self.errorMessage.isHidden = false
                        // Vibrate when error occurred
                        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                    }
                }
            }
        }
    }
}
