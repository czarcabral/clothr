//
//  Utils.swift
//  clothr
//
//  Created by Czar Vince Gabriel Cabral on 11/25/17.
//  Copyright © 2017 cmps115. All rights reserved.
//

import Foundation
import Parse

class Utils {
	
	// returns Parse's error message
	static func getParseErrorMessage(error: NSError) -> String {
		return (error.userInfo["error"] as? String)!
	}
	
	// creates and displays Parse's error as an alert
	static func getErrorAlert(errorMessage: String) -> UIAlertController {
		// Create an alert text box
		let alert = UIAlertController(title:"", message:"", preferredStyle: .alert)
		
		// Set font of the title and message
		let titleFont:[NSAttributedStringKey : Any] = [ NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue) : UIFont(name: "HelveticaNeue", size: 18)! ]
		let messageFont:[NSAttributedStringKey : Any] = [ NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue) : UIFont(name: "HelveticaNeue-Thin", size: 14)! ]
		
		// Choose which error message to display
		var attributedTitle: NSMutableAttributedString
		var attributedMessage: NSMutableAttributedString

		switch errorMessage {
		case "password is required." :
			attributedTitle = NSMutableAttributedString(string: "Password Required", attributes: titleFont)
			attributedMessage = NSMutableAttributedString(string: "Please try again.", attributes: messageFont)
		case "username/email is required." :
			attributedTitle = NSMutableAttributedString(string: "Username Required", attributes: titleFont)
			attributedMessage = NSMutableAttributedString(string: "Please try again.", attributes: messageFont)
        case "email is required." :
            attributedTitle = NSMutableAttributedString(string: "Email Required", attributes: titleFont)
            attributedMessage = NSMutableAttributedString(string: "Please try again.", attributes: messageFont)
		case "Email address format is invalid." :
			attributedTitle = NSMutableAttributedString(string: "Invalid Email", attributes: titleFont)
			attributedMessage = NSMutableAttributedString(string: "Format email as email@example.com \nPlease try again.", attributes: messageFont)
		case "Account already exists for this username." :
			attributedTitle = NSMutableAttributedString(string: "Whoops!", attributes: titleFont)
			attributedMessage = NSMutableAttributedString(string: "Account already exists for this username. Please try again.", attributes: messageFont)
		default :
			attributedTitle = NSMutableAttributedString(string: "Invalid Username/Password", attributes: titleFont)
			attributedMessage = NSMutableAttributedString(string: "The username and/or password you entered is incorrect. Please try again.", attributes: messageFont)
		}

		alert.setValue(attributedTitle, forKey: "attributedTitle")
		alert.setValue(attributedMessage, forKey: "attributedMessage")
		
		// Add Try again button to dismiss alert
		let tryAgain = UIAlertAction(title: "Try Again", style: .default, handler: { (action) -> Void in })
		alert.addAction(tryAgain)
		
		return alert
	}
    
}

extension UIAlertController {
    func show() {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = UIViewController()
        window.windowLevel = UIWindowLevelAlert
        window.makeKeyAndVisible()
        window.rootViewController?.present(self, animated: false, completion: nil)
    }
}
