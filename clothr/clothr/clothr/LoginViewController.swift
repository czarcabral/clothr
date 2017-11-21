//
//  LoginViewController.swift
//  clothr
//
//  Created by Gilbert Aragon on 11/14/17.
//  Copyright © 2017 cmps115. All rights reserved.
//
//  Login view controller. Page where user logs in.

import UIKit
import Parse

class LoginViewController: UIViewController {
    
    @IBOutlet weak var userUsername: UITextField!
    @IBOutlet weak var userPassword: UITextField!
	
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // when login button is pressed, go to the swipe page or send the user an error alert
    @IBAction func pressLogin(_ sender: Any) {
		tryLogin()
	}
	
	// try logging in using Parse
	func tryLogin() {
		let username = userUsername.text
		let password = userPassword.text
		
		PFUser.logInWithUsername(inBackground: username!, password: password!, block: { (user, error) in
			if error != nil {
				self.handleParseLoginError(error: error! as NSError)
			} else {
				self.login()
			}
		})
	}
	
	// deal with Parse login errors
	func handleParseLoginError(error: NSError) {
		let errorMessage = Utils.getParseErrorMessage(error: error) as String
		let alert = Utils.getErrorAlert(errorMessage: errorMessage)
		present(alert, animated: true, completion: nil)
	}
	
	// log in and move on to the next page
	func login() {
		print("Login successful")
		performSegue(withIdentifier: "loginToSwipe", sender: self)
	}
	
}
