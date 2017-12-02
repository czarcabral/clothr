//
//  SettingsViewModel.swift
//  clothr
//
//  Created by Gilbert Aragon on 11/26/17.
//  Copyright © 2017 cmps115. All rights reserved.
//

import UIKit

enum SettingsViewModelItemType {
    case changeInfo
    case tutorial
    case aboutUs
}

protocol SettingsViewModelItem {
    var type: SettingsViewModelItemType { get }
    var rowCount: Int { get }
    var sectionTitle: String  { get }
    var isCollapsible: Bool { get }
    var isCollapsed: Bool { get set }
}

extension SettingsViewModelItem {
    var rowCount: Int {
        return 1
    }
    
    var isCollapsible: Bool {
        return true
    }
}

class SettingsViewModel: NSObject {
    var items = [SettingsViewModelItem]()
    let section_backgroundcolor:[UIColor] = [UIColor.init(red: 0.604, green: 0.906, blue: 0.953, alpha: 0.75), UIColor.init(red: 0.0, green: 0.620, blue: 0.698, alpha: 0.75), UIColor.init(red: 0.714, green: 0.0, blue: 0.09, alpha: 0.75)]
    
    var reloadSections: ((_ section: Int) -> Void)?
    
    override init() {
        super.init()
        let userSetting = Settings()
        
        if let userName = userSetting.userName, let userEmail = userSetting.userEmail {
            let changeInfo = SettingsViewModelChangeUserInfoItem(userName: userName, userEmail: userEmail)
            items.append(changeInfo)
        }
        
        if let tut = userSetting.tut {
            let tutorial = SettingsViewModelTutorialItem(tutorial: tut)
            items.append(tutorial)
        }
        
        if let description = userSetting.description {
            let aboutUs = SettingsViewModelAboutUsItem(description: description)
            items.append(aboutUs)
        }
    }
}

extension SettingsViewModel: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let item = items[section]
        
        guard item.isCollapsible else {
            return item.rowCount
        }
        
        if item.isCollapsed {
            return 0
        } else {
            return item.rowCount
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.section]
        switch item.type {
        case .changeInfo:
            if let cell = tableView.dequeueReusableCell(withIdentifier: ChangeInfoCell.identifier, for: indexPath) as? ChangeInfoCell {
                cell.item = item
                return cell
            }
        case .tutorial:
            if let cell = tableView.dequeueReusableCell(withIdentifier: TutorialCell.identifier, for: indexPath) as? TutorialCell {
                cell.item = item
                return cell
            }
        case .aboutUs:
            if let cell = tableView.dequeueReusableCell(withIdentifier: AboutUsCell.identifier, for: indexPath) as? AboutUsCell {
                cell.item = item
                return cell
            }
        }
        
        return UITableViewCell()
    }
}

extension SettingsViewModel: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: HeaderView.identifier) as? HeaderView {
            headerView.item = items[section]
            headerView.section = section
            headerView.delegate = self
            headerView.contentView.backgroundColor = section_backgroundcolor[section]
            return headerView
        }
        return UIView()
    }
}

extension SettingsViewModel: HeaderViewDelegate {
    func toggleSection(header: HeaderView, section: Int) {
        var item = items[section]
        if item.isCollapsible {
            
            // Toggle collapse
            let collapsed = !item.isCollapsed
            item.isCollapsed = collapsed
            header.setCollapsed(collapsed: collapsed)
            
            // Adjust the number of the rows inside the section
            reloadSections?(section)
        }
    }
}

class SettingsViewModelChangeUserInfoItem: SettingsViewModelItem {
    var type: SettingsViewModelItemType {
        return .changeInfo
    }
    
    var sectionTitle: String {
        return "Main Info"
    }
    
    var isCollapsed = true
    
    let userName: String
    let userEmail: String
    
    init(userName: String, userEmail: String) {
        self.userName = userName
        self.userEmail = userEmail
    }
}

class SettingsViewModelTutorialItem: SettingsViewModelItem {
    var type: SettingsViewModelItemType {
        return .tutorial
    }
    
    var sectionTitle: String {
        return "Tutorial"
    }
    
    var isCollapsed = true
    
    let tutorial: String
    
    init(tutorial: String) {
        self.tutorial = tutorial
    }
}

class SettingsViewModelAboutUsItem: SettingsViewModelItem {
    var type: SettingsViewModelItemType {
        return .aboutUs
    }
    
    var sectionTitle: String {
        return "About Us"
    }
    
    var isCollapsed = true
    
    let description: String
    
    init(description: String) {
        self.description = description
    }
}
