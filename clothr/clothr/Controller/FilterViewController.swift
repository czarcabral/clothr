//
//  FilterViewController.swift
//  clothr
//
//  Created by Andrew Guterres on 11/20/17.
//  Copyright © 2017 cmps115. All rights reserved.
//

import UIKit
import Parse

class FilterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var filterTable: UITableView!
    var filterArray : [String] = ["Retailer", "Brand", "Price Range", "Color"]
    var selectedFilter: NSString = ""
    var selectedIndex: NSInteger = -1
    override func viewDidLoad() {
        super.viewDidLoad()
        filterTable.estimatedRowHeight=50;
        filterTable.rowHeight=UITableViewAutomaticDimension
        filterTable.tableFooterView = UIView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterArray.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "filterCell", for: indexPath) as! FilterTableViewCell
        cell.selectionStyle = .none
        cell.label.text=filterArray[indexPath.row]
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(selectedIndex == indexPath.row) {
            return 425
        } else {
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(selectedIndex == indexPath.row) {
            selectedIndex = -1
        } else {
            selectedIndex = indexPath.row
        }
        self.filterTable.beginUpdates()
        self.filterTable.endUpdates()
    }
    

}
