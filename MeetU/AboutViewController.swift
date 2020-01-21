//
//  AboutViewController.swift
//  MeetU
//
//  Created by Alexandre dos Santos Rodrigues on 20/01/2020.
//  Copyright © 2020 MeetU Inc. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if UserController.shared.darkMode {
            overrideUserInterfaceStyle = .dark
        } else {
            overrideUserInterfaceStyle = .light
        }
    }

}
