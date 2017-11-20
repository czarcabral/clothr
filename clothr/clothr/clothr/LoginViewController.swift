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
    var loginSuccess = false
    
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
	
	// log in and move on to the next page
	func login() {
		print("Login successful")
		loginSuccess = true
		performSegue(withIdentifier: "loginToSwipe", sender: self)
	}
	
	// deal with Parse login errors
	func handleParseLoginError(error: NSError) {
		//		var errorMessage = "Login failed - Try Again"
		let errorMessage = getParseErrorMessage(error: error)
		
		displayErrorAlert(errorMessage: errorMessage)
	}
	
	// returns Parse's error message
	func getParseErrorMessage(error: NSError) -> String {
		return (error.userInfo["error"] as? String)!
	}
	
	// creates and displays Parse's error as an alert
	func displayErrorAlert(errorMessage: String) {
		// Create an alert text box
		let alert = UIAlertController(title:"", message:"", preferredStyle: .alert)
		
		// Change font of the title and message
		let titleFont:[NSAttributedStringKey : Any] = [ NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue) : UIFont(name: "HelveticaNeue", size: 18)! ]
		let messageFont:[NSAttributedStringKey : Any] = [ NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue) : UIFont(name: "HelveticaNeue-Thin", size: 14)! ]
		
		// Try again button to dismiss alert
		let tryAgain = UIAlertAction(title: "Try Again", style: .default, handler: { (action) -> Void in })
		
		// display alert message according to the error
		if errorMessage == "password is required." {
			let attributedTitle = NSMutableAttributedString(string: "Password Required", attributes: titleFont)
			let attributedMessage = NSMutableAttributedString(string: "Please try again.", attributes: messageFont)
			alert.setValue(attributedTitle, forKey: "attributedTitle")
			alert.setValue(attributedMessage, forKey: "attributedMessage")
		} else if errorMessage == "username/email is required." {
			let attributedTitle = NSMutableAttributedString(string: "Invalid Username", attributes: titleFont)
			let attributedMessage = NSMutableAttributedString(string: "Please try again.", attributes: messageFont)
			alert.setValue(attributedTitle, forKey: "attributedTitle")
			alert.setValue(attributedMessage, forKey: "attributedMessage")
		} else {
			let attributedTitle = NSMutableAttributedString(string: "Invalid Username/Password", attributes: titleFont)
			let attributedMessage = NSMutableAttributedString(string: "The username and/or password you entered is incorrect. Please try again.", attributes: messageFont)
			alert.setValue(attributedTitle, forKey: "attributedTitle")
			alert.setValue(attributedMessage, forKey: "attributedMessage")
		}
		
		// Add the try again button and display the alert box
		alert.addAction(tryAgain)
		self.present(alert, animated: true, completion: nil)
	}
	
}
