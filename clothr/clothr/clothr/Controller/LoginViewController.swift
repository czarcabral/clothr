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

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Programatically configure textfields' delegates and tags
        usernameTF.delegate = self
        usernameTF.tag = 0
        passwordTF.delegate = self
        passwordTF.tag = 1
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
            tryLogin()
        }
        
        return false
    }
    
    // Dismisses keyboard when User touches outside of the keyboard while typing
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // When login button is pressed, log in and move onto Main page or send the user an error alert and remain on Login page
    @IBAction func pressLogin(_ sender: Any) {
		tryLogin()
	}
	
	// Tries logging in using Parse
	func tryLogin() {
        let username = usernameTF.text
		let password = passwordTF.text
		
		PFUser.logInWithUsername(inBackground: username!, password: password!, block: { (user, error) in
			if error != nil {
				self.handleParseLoginError(error: error! as NSError)
			} else {
				self.login()
			}
		})
	}
	
	// Determines which error occurred and displays it to User
	func handleParseLoginError(error: NSError) {
		let errorMessage = Utils.getParseErrorMessage(error: error) as String
		let alert = Utils.getErrorAlert(errorMessage: errorMessage) as UIAlertController
		present(alert, animated: true, completion: nil)
	}
	
	// Logs in and moves onto to the next page
	func login() {
		print("Login successful")
		performSegue(withIdentifier: "LoginToMain", sender: self)
	}
	
}
