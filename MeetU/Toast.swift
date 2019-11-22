//
//  Toast.swift
//  MeetU
//
//  Created by Ricardo Miguel da Silva Rodrigues on 21/11/2019.
//  Copyright © 2019 MeetU Inc. All rights reserved.
//

import Foundation

public class Toast {
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
