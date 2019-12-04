//
//  EmailViewController.swift
//  MeetU
//
//  Created by Filipa Reis da Fonte on 20/11/2019.
//  Copyright © 2019 MeetU Inc. All rights reserved.
//

import UIKit

import Firebase

@objc(LoginViewController)
class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
    @IBAction func login(_ sender: UIButton) {
        guard let email = self.emailField.text else {
            print("email can't be empty")
            return
        }
        guard let password = self.passwordField.text else {
            print("password can't be empty")
            return
        }
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] user, error in
          guard let strongSelf = self else { return }
          // ...
        }
        Analytics.logEvent(AnalyticsEventLogin, parameters: [
            AnalyticsParameterMethod: method
        ])
    }
    
    /*@IBAction func didTapEmailLogin(_ sender: AnyObject) {
    guard let email = self.emailField.text, let password = self.passwordField.text else {
      self.showMessagePrompt("email/password can't be empty")
      return
    }
    showSpinner {
      Auth.auth().signIn(withEmail: email, password: password) { [weak self] user, error in
        guard let strongSelf = self else { return }
        strongSelf.hideSpinner {
          if let error = error {
            strongSelf.showMessagePrompt(error.localizedDescription)
            return
          }
          strongSelf.navigationController?.popViewController(animated: true)
        }
      }
    }
    }

    /** @fn requestPasswordReset
    @brief Requests a "password reset" email be sent.
    */
    @IBAction func didRequestPasswordReset(_ sender: AnyObject) {
    showTextInputPrompt(withMessage: "Email:") { [weak self] userPressedOK, email in
      guard let strongSelf = self, let email = email else {
        return
      }
      strongSelf.showSpinner {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
          strongSelf.hideSpinner {
            if let error = error {
              strongSelf.showMessagePrompt(error.localizedDescription)
              return
            }
            strongSelf.showMessagePrompt("Sent")
          }
        }
      }
    }
    }

    /** @fn getProvidersForEmail
    @brief Prompts the user for an email address, calls @c FIRAuth.getProvidersForEmail:callback:
    and displays the result.
    */
    @IBAction func didGetProvidersForEmail(_ sender: AnyObject) {
    showTextInputPrompt(withMessage: "Email:") { [weak self] userPressedOK, email in
      guard let strongSelf = self else { return }
      guard let email = email else {
        strongSelf.showMessagePrompt("email can't be empty")
        return
      }
      strongSelf.showSpinner {
        Auth.auth().fetchSignInMethods(forEmail: email) { methods, error in
          strongSelf.hideSpinner {
            if let error = error {
              strongSelf.showMessagePrompt(error.localizedDescription)
              return
            }
            strongSelf.showMessagePrompt(methods!.joined(separator: ", "))
          }
        }
      }
    }
    }

    @IBAction func didCreateAccount(_ sender: AnyObject) {
    showTextInputPrompt(withMessage: "Email:") {  [weak self] userPressedOK, email in
      guard let strongSelf = self else { return }
      guard let email = email else {
        strongSelf.showMessagePrompt("email can't be empty")
        return
      }
      strongSelf.showTextInputPrompt(withMessage: "Password:") { userPressedOK, password in
        guard let password = password else {
          strongSelf.showMessagePrompt("password can't be empty")
          return
        }
        strongSelf.showSpinner {
          Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            strongSelf.hideSpinner {
              guard let user = authResult?.user, error == nil else {
                strongSelf.showMessagePrompt(error!.localizedDescription)
                return
              }
              print("\(user.email!) created")
              strongSelf.navigationController?.popViewController(animated: true)
            }
          }
        }
      }
    }
    }*/

}
