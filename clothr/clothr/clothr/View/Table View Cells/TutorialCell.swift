//
//  TutorialCell.swift
//  clothr
//
//  Created by Gilbert Aragon on 11/26/17.
//  Copyright © 2017 cmps115. All rights reserved.
//

import UIKit

class TutorialCell: UITableViewCell {
    @IBOutlet weak var tutorialText: UITextView?
    @IBOutlet weak var scrollView: UIScrollView!
    
    var imageArray = [UIImage]()
    
    
    var item: SettingsViewModelItem? {
        didSet {
            guard let item = item as? SettingsViewModelTutorialItem else {
                return
            }
            
            scrollView.contentSize.height = 2000
            
            imageArray = [#imageLiteral(resourceName: "thumbs-up"),#imageLiteral(resourceName: "thumbs-down"),#imageLiteral(resourceName: "thumbs-up")]
            
            
                
            tutorialText?.text = item.tutorial
           
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
}
