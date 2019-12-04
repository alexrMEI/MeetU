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
        if(usernameTxt.text?.isEmpty == true || emailTxt.text?.isEmpty == true || passwordTxt.text?.isEmpty == true) {
            showToast(controller: self, message: "Please fill all the fields", seconds: 2.0)
        } else {
            Auth.auth().createUser(withEmail: emailTxt.text!, password: passwordTxt.text!) { authResult, error in
                if (error == nil){
                    // instantiates a new User()
                    self.user = User.init(name: self.usernameTxt!.text!, email: self.emailTxt!.text!)
                    // Create a node with the user information
                    self.ref.child("Users").child(authResult!.user.uid).setValue(["Name": self.user!.name, "Email": self.user!.email])
                    
                    // Save user info to UserDefaults
                    //let userInfo = ["email": self.user!.email, "password": self.passwordTxt.text!, "uid": authResult!.user.uid]
                    //UserDefaults.standard.set(userInfo, forKey: "userDetails")
                    // OR
                    UserDefaults.standard.set(self.user!.name, forKey: "userName")
                    UserDefaults.standard.set(self.user!.email, forKey: "userEmail")
                    UserDefaults.standard.set(authResult!.user.uid, forKey: "userUID")
                    
                    // open the new page if creation is successful
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let secondVC = storyboard.instantiateViewController(identifier: "MenuViewController")
                    
                    secondVC.modalPresentationStyle = .fullScreen
                    secondVC.modalTransitionStyle = .crossDissolve
                    
                    self.present(secondVC, animated: true, completion: nil)
                }
                else{
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
