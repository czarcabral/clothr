//
//  SettingsViewController.swift
//  clothr
//
//  Created by Gilbert Aragon on 11/16/17.
//  Copyright © 2017 cmps115. All rights reserved.
//
//  Settings View Controller. Where user can change their settings, log out, or delete their account.

import UIKit
import Parse

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//------------------------------------------log out button function---------------------------------------//
    @IBAction func logOutPressed(_ sender: Any) {
        // show user logged in
        // print("current user: ", PFUser.current() as Any)
        
        // log user out, PFUser.current() = nil
        PFUser.logOut()
        _ = PFUser.current()
        
        // check user is logged out
        // print("user: ", PFUser.current() as Any)
        
        // go to home page after logging out
        guard (navigationController?.popToRootViewController(animated: true)) != nil
            else {
                print("No View Controller to Pop")
                return
        }
    }
}
