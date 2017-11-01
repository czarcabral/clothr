//
//  ViewControllerTableViewCell.swift
//  clothr
//
//  Created by Andrew Guterres on 10/30/17.
//  Copyright © 2017 cmps115. All rights reserved.
//

import UIKit

class SaveControllerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var productImage: UIImageView!
    
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

