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

class CreateAccountViewController: UIViewController {

    var ref: DatabaseReference! = Database.database().reference()
    
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    
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

    @IBAction func onClickCreateAccount(_ sender: Any) {
        Auth.auth().createUser(withEmail: emailTxt.text!, password: passwordTxt.text!) { authResult, error in
            if (error == nil){
                self.ref.child("Users").child(authResult!.user.uid).setValue(User.init(name: self.usernameTxt!.text!, email: self.emailTxt!.text!)) //TODO: Array or Dictionary
            }
            else{
                print(error ?? "Erro")
            }
        }
    }
}
