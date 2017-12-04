//
//  AboutUsCell.swift
//  clothr
//
//  Created by Gilbert Aragon on 11/26/17.
//  Copyright © 2017 cmps115. All rights reserved.
//

import UIKit

class AboutUsCell: UITableViewCell {
    @IBOutlet weak var aboutUsText: UITextView!
    
    var item: SettingsViewModelItem? {
        didSet {
            guard let item = item as? SettingsViewModelAboutUsItem else {
                return
            }
            
            aboutUsText?.text = item.description
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
}
