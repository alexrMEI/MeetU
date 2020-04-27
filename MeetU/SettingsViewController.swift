//
//  SettingsViewController.swift
//  MeetU
//
//  Created by Alexandre dos Santos Rodrigues on 20/01/2020.
//  Copyright © 2020 MeetU Inc. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet weak var darkModeSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func setDarkMode(_ sender: UISwitch) {
        print(darkModeSwitch.isOn)
        if (darkModeSwitch.isOn) {
            UserController.shared.darkMode = true
            overrideUserInterfaceStyle = .dark
        } else {
            UserController.shared.darkMode = false
            overrideUserInterfaceStyle = .light
        }
    }
}
