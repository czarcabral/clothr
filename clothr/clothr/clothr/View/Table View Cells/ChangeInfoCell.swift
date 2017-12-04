//
//  ChangeInfoCell.swift
//  clothr
//
//  Created by Gilbert Aragon on 11/26/17.
//  Copyright © 2017 cmps115. All rights reserved.
//

import UIKit
import Parse

class ChangeInfoCell: UITableViewCell {

    @IBOutlet weak var userName: UILabel?
    @IBOutlet weak var userEmail: UILabel?
    
    var item: SettingsViewModelItem? {
        didSet {
            guard  let item = item as? SettingsViewModelChangeUserInfoItem else {
                return
            }
            
            userName?.text = item.userName
            userEmail?.text = item.userEmail
        }
    }
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // When delete account is pressed, delete the current user's account and return to the Start page
    @IBAction func deleteAccountPressed(_ sender: Any) {
        let alert = UIAlertController(title:"Warning", message:"Are you sure you want to delete your account?", preferredStyle: .alert)
        let yes = UIAlertAction(title: "Yes", style: .destructive, handler: { (action) -> Void in
            self.tryDeleteAccount()
        })
        let no = UIAlertAction(title: "No", style: .default, handler: { (action) -> Void in })
        
        alert.addAction(yes)
        alert.addAction(no)
        alert.show()
    }
    
    // Tries to delete the user's account from the Parse database
    func tryDeleteAccount() {
        PFUser.current()?.deleteInBackground(block: { (success, error) -> Void in
            self.deleteAccount(success: success)
        })
    }
    
    // Resets the root view to the Start page
    func returnStartView() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "StartView")
        UIApplication.shared.keyWindow?.rootViewController = viewController
    }
    
    // Deletes the account
    func deleteAccount(success: Bool) {
        print("success = \(success)")
        PFUser.logOut()
        returnStartView()
    }
    
    // When reset password is pressed, have the user enter their new credentials in an alert box
    @IBAction func resetPasswordPressed(_ sender: Any) {
        let alert = UIAlertController(title:"Warning", message:"Are you sure you want to reset your password?", preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: { (_ textField : UITextField!) -> Void in
            textField.placeholder = "Current Password"
            textField.isSecureTextEntry = true
        })
        alert.addTextField(configurationHandler: { (_ textField : UITextField!) -> Void in
            textField.placeholder = "New Password"
            textField.isSecureTextEntry = true
        })
        alert.addTextField(configurationHandler: {(_ textField: UITextField) -> Void in
            textField.placeholder = "New Password, again"
            textField.isSecureTextEntry = true
        })

        let left = UIAlertAction(title: "Save", style: .default, handler: { (action) -> Void in
            self.tryResetPassword(alert)
        })
        let right = UIAlertAction(title: "Cancel", style: .default, handler: { (action) -> Void in
            // Nothing here
        })
        alert.addAction(left)
        alert.addAction(right)
        
        alert.show()
    }
    
    // Try to reset the new password
    func tryResetPassword(_ alert: UIAlertController) {
        let oldPasswordTF = alert.textFields![0] as UITextField
        let newPassword1TF = alert.textFields![1] as UITextField
        let newPassword2TF = alert.textFields![2] as UITextField
        
        PFUser.current()?.password = newPassword1TF.text
    }
}
