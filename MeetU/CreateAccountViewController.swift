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

class CreateAccountViewController: UIViewController {

    var ref: DatabaseReference! = Database.database().reference()
        
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
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
        var name = usernameTxt.text
        var email = emailTxt.text
        var password = passwordTxt.text
        if(name?.isEmpty == true || email?.isEmpty == true || password?.isEmpty == true) {
            showToast(controller: self, message: "Please fill all the fields", seconds: 2.0)
        } else {
            
            SwiftOverlays.showTextOverlay(self.view, text: "Signing Up...")
             
            UserController.registerUser(withName: name?, email: email?, password: password?) { [weak weakSelf = self] (status) in
                DispatchQueue.main.async {
                    
                    SwiftOverlays.removeAllBlockingOverlays()
                    
                    if status == true
                    {
                       // open the new page if creation is successful
                       let storyboard = UIStoryboard(name: "Main", bundle: nil)
                       let secondVC = storyboard.instantiateViewController(identifier: "MenuViewController")
                       
                       secondVC.modalPresentationStyle = .fullScreen
                       secondVC.modalTransitionStyle = .crossDissolve
                       
                       self.present(secondVC, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    // MARK: Show Toast on create User clicked if fields are empty
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
