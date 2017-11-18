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
    
    @IBAction func deleteAccountPressed(_ sender: Any) {
        // Create an alert text box
        let alert = UIAlertController(title:"Warning", message:"Are you sure you want to delete your account?", preferredStyle: .alert)
        
        // Change font of the title and message
        //let titleFont:[NSAttributedStringKey : Any] = [ NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue) : UIFont(name: "HelveticaNeue", size: 18)! ]
        //let messageFont:[NSAttributedStringKey : Any] = [ NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue) : UIFont(name: "HelveticaNeue-Thin", size: 14)! ]
        
        // Yes button to delete account
        let yes = UIAlertAction(title: "Yes", style: .destructive, handler: { (action) -> Void in
            PFUser.current()?.deleteInBackground(block: { (deleteSuccessful, error) -> Void in
                print("success = \(deleteSuccessful)")
                PFUser.logOut()
            })
            
            // go to home page after deleting account
            guard (self.navigationController?.popToRootViewController(animated: true)) != nil
                else {
                    print("No View Controller to Pop")
                    return
            }
        })
        
        // No button to not delete account
        let no = UIAlertAction(title: "No", style: .default, handler: { (action) -> Void in })
        
        // Add the buttons and display the alert box
        alert.addAction(yes)
        alert.addAction(no)
        self.present(alert, animated: true, completion: nil)
    }
}
