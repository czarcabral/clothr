//
//  LoginViewController.swift
//  clothr
//
//  Created by Gilbert Aragon on 11/14/17.
//  Copyright © 2017 cmps115. All rights reserved.
//
// Login view controller. Page where user logs in.

import UIKit
import Parse

class LoginViewController: UIViewController {
    
    @IBOutlet weak var userUsername: UITextField!
    @IBOutlet weak var userPassword: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    var loginSuccess = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        errorLabel.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        if let username = userUsername.text {
            if let password = userPassword.text {
                PFUser.logInWithUsername(inBackground: username, password: password, block: { (user, error) in
                    if error != nil {
                        // If login fails, print out an error message
                        var errorMessage = "Login failed - Try Again"
                        
                        if let newError = error as NSError? {
                            if let detailError = newError.userInfo["error"] as? String {
                                errorMessage = detailError
                            }
                        }
                        
                        self.errorLabel.isHidden = false
                        self.errorLabel.text = errorMessage
                        
                    } else {
                        // If login works, go to next page
                        print("Login successful")
                        self.loginSuccess = true
                        self.performSegue(withIdentifier: "loginToSwipe", sender: self)
                    }
                })
            }
        }
    }
}
