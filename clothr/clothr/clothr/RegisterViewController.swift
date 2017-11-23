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
    
    @IBOutlet weak var userUsername: UITextField!
    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var userPassword: UITextField!
    var registerSuccess = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func registerPressed(_ sender: Any) {
        // create a user
        let user = PFUser()
        
        // Parse doesn't make email requried, so a conditional is used to make sure user fills
        // out the email text box
        if !((userEmail.text?.isEmpty)!) {
            // assign user input to the appropriate new user fields
            user.username = userUsername.text
            user.password = userPassword.text
            user.email = userEmail.text
        }
        
        // show error if there was a problem signing up
        // otherwise, create a new user in the database and go to swipe page
        user.signUpInBackground (block: { (success, error) in
            if error != nil || (self.userEmail.text?.isEmpty)! {
                var errorMessage = "Sign Up failed - Try Again"
                
                if let newError = error as NSError? {
                    if let detailError = newError.userInfo["error"] as? String {
                        errorMessage = detailError
                    }
                }
                
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
            } else {
                print("Register successful")
                let savedObject = PFObject(className: "storages")
                savedObject["user"] = PFUser.current()?.username
                savedObject["pagingIndexes"] = [String: NSNumber]()
                savedObject["savedProductImages"] = [Any]()
                savedObject["savedProductNames"] = [Any]()
                savedObject["savedProductPrices"] = [Any]()
                savedObject["savedProductURL"] = [Any]()
                savedObject["saleBooleans"] = [String]()
                savedObject.saveInBackground() { (success,error) in print("object saved")}
                self.registerSuccess = true
                self.performSegue(withIdentifier: "registerToSwipe", sender: self)
            }
        })
    }
    
}
