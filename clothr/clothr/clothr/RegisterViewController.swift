//
//  RegisterViewController.swift
//  clothr
//
//  Created by Gilbert Aragon on 11/14/17.
//  Copyright © 2017 cmps115. All rights reserved.
//
//  Register View Controller. Where user signs up.

import UIKit
import Parse

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    var registerSuccess = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	// tries to register the user
    @IBAction func pressRegister(_ sender: Any) {
		tryRegister()
	}
	
	// tries to sign up using Parse
	func tryRegister() {
		let user = PFUser()
		
		user.username = usernameTF.text
		user.email = emailTF.text
		user.password = passwordTF.text
		
		// show error if there was a problem signing up
		// otherwise, create a new user in the database and go to swipe page
		user.signUpInBackground (block: { (success, error) in
			if error != nil || (self.emailTF.text?.isEmpty)! {
				self.handleParseSignupError(error: error! as NSError)
			} else {
				self.register(user: user)
			}
		})
	}

	func handleParseSignupError(error: NSError) {
		let errorMessage = getParseErrorMessage(error: error)
		displayErrorAlert(errorMessage: errorMessage)
	}
	
	func getParseErrorMessage(error: NSError) -> String {
		return (error.userInfo["error"] as? String)!
	}
	
	func displayErrorAlert(errorMessage: String) {
		// Create an alert text box
		let alert = UIAlertController(title:"", message:"", preferredStyle: .alert)

		// Change font of the title and message
		let titleFont:[NSAttributedStringKey : Any] = [ NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue) : UIFont(name: "HelveticaNeue", size: 18)! ]
		let messageFont:[NSAttributedStringKey : Any] = [ NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue) : UIFont(name: "HelveticaNeue-Thin", size: 14)! ]

		// Try again button to dismiss alert
		let tryAgain = UIAlertAction(title: "Try Again", style: .default, handler: { (action) -> Void in })
		
		// display alert message according to the error
		if errorMessage == "password is required" {
			let attributedTitle = NSMutableAttributedString(string: "Password Required", attributes: titleFont)
			let attributedMessage = NSMutableAttributedString(string: "Please try again.", attributes: messageFont)
			
			alert.setValue(attributedTitle, forKey: "attributedTitle")
			alert.setValue(attributedMessage, forKey: "attributedMessage")
		} else if errorMessage == "Email address format is invalid." {
			let attributedTitle = NSMutableAttributedString(string: "Invalid Email", attributes: titleFont)
			let attributedMessage = NSMutableAttributedString(string: "Format email as email@example.com \nPlease try again.", attributes: messageFont)
			
			alert.setValue(attributedTitle, forKey: "attributedTitle")
			alert.setValue(attributedMessage, forKey: "attributedMessage")
		} else if errorMessage == "Account already exists for this username." {
			let attributedTitle = NSMutableAttributedString(string: "Whoops!", attributes: titleFont)
			let attributedMessage = NSMutableAttributedString(string: "Account already exists for this username. Please try again.", attributes: messageFont)
			
			alert.setValue(attributedTitle, forKey: "attributedTitle")
			alert.setValue(attributedMessage, forKey: "attributedMessage")
		} else {
			let attributedTitle = NSMutableAttributedString(string: "Username/Email Required", attributes: titleFont)
			let attributedMessage = NSMutableAttributedString(string: "Please try again.", attributes: messageFont)
			
			alert.setValue(attributedTitle, forKey: "attributedTitle")
			alert.setValue(attributedMessage, forKey: "attributedMessage")
		}
		
		// Add the try again button and display the alert box
		alert.addAction(tryAgain)
		self.present(alert, animated: true, completion: nil)
	}
	
	func register(user: PFUser) {
		print("Register successful")
		registerSuccess = true

		setUpUser(user: user)
		
		performSegue(withIdentifier: "registerToSwipe", sender: self)
	}
	
	// function
	func setUpUser(user: PFUser) {
		let savedObject = PFObject(className: "storages")
		savedObject["user"] = PFUser.current()?.username
		savedObject["pagingIndexes"] = [String: NSNumber]()
		savedObject["savedProductImages"] = [Any]()
		savedObject["savedProductNames"] = [Any]()
		savedObject["savedProductPrices"] = [Any]()
		savedObject["savedProductURL"] = [Any]()
		savedObject["saleBooleans"] = [String]()
		savedObject.saveInBackground() { (success,error) in
			print("object saved")
		}
	}
	
}
