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
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
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
    
    //  Deletes the account
    func deleteAccount(success: Bool) {
        print("success = \(success)")
        PFUser.logOut()
        returnStartView()
    }
    
    // reset password
    @IBAction func resetPasswordPressed(_ sender: Any) {
        PFUser.requestPasswordResetForEmail(inBackground: (userEmail?.text)!)
    }
}
