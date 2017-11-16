//
//  RegisterViewController.swift
//  clothr
//
//  Created by Gilbert Aragon on 11/14/17.
//  Copyright © 2017 cmps115. All rights reserved.
//
// Register View Controller. Where user signs up.

import UIKit
import Parse

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var userUsername: UITextField!
    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var userPassword: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    var registerSuccess = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        errorLabel.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func registerPressed(_ sender: Any) {
        // create a user
        let user = PFUser()
        
        // assign user input to the appropriate new user fields
        user.username = userUsername.text
        user.password = userPassword.text
        user.email = userEmail.text
        
        // show error if there was a problem signing up
        // otherwise, create a new user in the database and go to swipe page
        user.signUpInBackground (block: { (success, error) in
            if error != nil {
                var errorMessage = "Sign Up failed - Try Again"
                
                if let newError = error as NSError? {
                    if let detailError = newError.userInfo["error"] as? String {
                        errorMessage = detailError
                    }
                }
                
                self.errorLabel.isHidden = false
                self.errorLabel.text = errorMessage
            } else {
                print("Register successful")
                let savedObject = PFObject(className: "storages")
                savedObject["user"] = PFUser.current()?.username
                savedObject["pagingIndexes"] = [String: NSNumber]()
                savedObject["savedProductImages"] = [Any]()
                savedObject["savedProductNames"] = [Any]()
                savedObject["savedProductPrices"] = [Any]()
                savedObject["savedProductURL"] = [Any]()
                savedObject.saveInBackground() { (success,error) in print("object saved")}
                self.registerSuccess = true
                self.performSegue(withIdentifier: "registerToSwipe", sender: self)
            }
        })
    }
    
}
