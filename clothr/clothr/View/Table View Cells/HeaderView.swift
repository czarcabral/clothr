//
//  HeaderView.swift
//  clothr
//
//  Created by Gilbert Aragon on 11/28/17.
//  Copyright © 2017 cmps115. All rights reserved.
//

import UIKit

protocol HeaderViewDelegate: class {
    func toggleSection(header: HeaderView, section: Int)
}

class HeaderView: UITableViewHeaderFooterView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var arrowLabel: UILabel!
    var section: Int = 0
    weak var delegate: HeaderViewDelegate?
    
    var item: SettingsViewModelItem? {
        didSet {
            guard let item = item else {
                return
            }
            titleLabel?.text = item.sectionTitle
            setCollapsed(collapsed: item.isCollapsed)
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
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapHeader)))
    }
    
    @objc private func tapHeader(gestureRecognizer: UITapGestureRecognizer) {
        delegate?.toggleSection(header: self, section: section)
    }
    
    func setCollapsed(collapsed: Bool) {
        arrowLabel?.rotate(collapsed ? 0.0 : .pi)
    }
}

extension UIView {
    func rotate(_ toValue: CGFloat, duration: CFTimeInterval = 0.2) {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.toValue = toValue
        animation.duration = duration
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        self.layer.add(animation, forKey: nil)
    }
}
