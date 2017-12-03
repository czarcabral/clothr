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

class RegisterViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Programatically configure textfields' delegates and tags
        usernameTF.delegate = self
        usernameTF.tag = 0
        emailTF.delegate = self
        emailTF.tag = 1
        passwordTF.delegate = self
        passwordTF.tag = 2
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Determines what to do when User presses return while typing
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextTF = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextTF.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            tryRegister()
        }
        
        return false
    }
    
    // Dismisses keyboard when User touches outside of the keyboard while typing
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
	
	// When register button is pressed, register and move on to Main page or send User and error alert and remain on Register page
	@IBAction func pressRegister(_ sender: Any) {
		tryRegister()
	}
	
	// Tries to sign up using Parse
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
	
	// Determines which error occurred and displays it to User
	func handleParseSignupError(error: NSError) {
        var errorMessage: String
        if emailTF.text!.isEmpty {
            errorMessage = "email is required."
        } else {
            errorMessage = Utils.getParseErrorMessage(error: error)
        }
		let alert = Utils.getErrorAlert(errorMessage: errorMessage) as UIAlertController
		present(alert, animated: true, completion: nil)
	}
	
	// Registers the User and moves on to the Main page
	func register(user: PFUser) {
		print("Register successful")
		setUpUser(user: user)
		performSegue(withIdentifier: "RegisterToMain", sender: self)
	}
	
	// Sets up the User's stuff
	func setUpUser(user: PFUser) {
		let savedObject = PFObject(className: "storages")
		savedObject["user"] = PFUser.current()?.username
		savedObject["pagingIndexes"] = [String: NSNumber]()
		savedObject["savedProductImages"] = [Any]()
		savedObject["savedProductNames"] = [Any]()
		savedObject["savedProductPrices"] = [Any]()
		savedObject["savedProductURL"] = [Any]()
		savedObject["saleBooleans"] = [String]()
        savedObject["savedBrandNames"] = [Any]()
		savedObject.saveInBackground() { (success,error) in
			print("object saved")
		}
	}
	
}
