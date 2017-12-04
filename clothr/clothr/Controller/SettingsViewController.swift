//
//  SettingsViewController.swift
//  clothr
//
//  Created by Gilbert Aragon on 11/26/17.
//  Copyright © 2017 cmps115. All rights reserved.
//

import UIKit
import Parse

class SettingsViewController: UIViewController {
    
    fileprivate let viewModel = SettingsViewModel()
    @IBOutlet weak var settingsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.reloadSections = { [weak self] (section: Int) in
            self?.settingsTable?.beginUpdates()
            self?.settingsTable?.reloadSections([section], with: .fade)
            self?.settingsTable?.endUpdates()
        }
        
        settingsTable?.dataSource = viewModel
        settingsTable?.delegate = viewModel
        settingsTable?.rowHeight = 200
        settingsTable?.sectionHeaderHeight = 50
        settingsTable?.separatorStyle = .none
        settingsTable?.backgroundColor = UIColor.init(red: 0.902, green: 0.929, blue: 0.918, alpha: 1.0)
        
        //print(settingsTable?.rowHeight)
        settingsTable?.register(ChangeInfoCell.nib, forCellReuseIdentifier: ChangeInfoCell.identifier)
        settingsTable?.register(TutorialCell.nib, forCellReuseIdentifier: TutorialCell.identifier)
        settingsTable?.register(AboutUsCell.nib, forCellReuseIdentifier: AboutUsCell.identifier)
        settingsTable?.register(HeaderView.nib, forHeaderFooterViewReuseIdentifier: HeaderView.identifier)
    }
    
    // Log out the current User and return to start screen
    @IBAction func logOutPressed(_ sender: Any) {
        let alert = UIAlertController(title:"Logout of Clothr?", message:nil, preferredStyle: .alert)
        let left = UIAlertAction(title: "Cancel", style: .default, handler: { (action) -> Void in
            // Nothing
        })
        let right = UIAlertAction(title: "Continue", style: .default, handler: { (action) -> Void in
            self.tryLogout()
        })

        alert.addAction(left)
        alert.addAction(right)
        
        present(alert, animated: true, completion: nil)
    }
    
    // Try to Log out the current User
    func tryLogout() {
        PFUser.logOut()
        returnStartView()
    }
    
    // Resets the root view to the Start page
    func returnStartView() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "StartView")
        UIApplication.shared.keyWindow?.rootViewController = viewController
    }
    
}
