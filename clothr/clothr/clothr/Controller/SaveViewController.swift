//
//  SaveController.swift
//  clothr
//
//  Created by Andrew Guterres on 10/30/17.
//  Copyright © 2017 cmps115. All rights reserved.
//

import UIKit
import Parse
import SafariServices
var savedIndex: NSInteger=0
var checker2: NSInteger=5



class SaveViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let vc = ViewController()
    var savedImages=NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "images") as! Data) as? [Any]
    var savedNames=NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "names") as! Data) as? [Any]
    var savedPrices=NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "prices") as! Data) as? [Any]
    var savedURL=NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "url") as! Data) as? [Any]
    var savedBrand=NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "savedBrandNames") as! Data) as? [Any]
    var saleBool=NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "sales") as! Data) as? [String]
    
    @IBOutlet weak var tableview: UITableView!
    
    var refreshControl: UIRefreshControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.delegate=self
        tableview.dataSource=self
        tableview.tableFooterView = UIView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
//------------------------------------method to get middle image for swiping page-----------------------------------------//
    func getProductImage(_ imageView:UIImageView, _ cell:SaveControllerTableViewCell, _ index: Int)
    {
        let url = NSURL(string: savedImages![index] as! String)
        let request = URLRequest(url: url! as URL)
        let session = URLSession.shared
        
        let task = session.dataTask(with: request, completionHandler: {
            (
            data, response, error) in
            if data != nil
            {
                let image2 = UIImage(data: data!)
                if(image2 != nil)
                {
                    DispatchQueue.main.async(execute: {
                        imageView.image = image2
                        imageView.contentMode = .scaleAspectFit
                    })
                }
            }
        })
        
        task.resume()
        savedIndex+=1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedImages!.count
    }
    
//------------------------------------load custom made cells-----------------------------------------//
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SaveControllerTableViewCell
        getProductImage(cell.productImage, cell,indexPath.row)
        let priceCheck = saleBool![indexPath.row]       //if there is a sale, use the sale price instead
        if(priceCheck=="-1")
        {
            cell.productPrice.text=(savedPrices?[indexPath.row] as! String)
            cell.productSale.text=""
        } else  //if there is a sale, use sale price and put regular price below
        {
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: savedPrices?[indexPath.row] as! String)
            attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
            attributeString.addAttribute(NSAttributedStringKey.strikethroughColor, value: UIColor.red, range: NSMakeRange(0, attributeString.length))
            cell.productSale.attributedText = attributeString
            cell.productPrice.text=priceCheck
        }
        cell.productName.text=(savedNames?[indexPath.row] as! String)
        cell.productBrand.text="Brand: " + (savedBrand?[indexPath.row] as! String)
        return(cell)
    }
    
//------------------------------------bring user to product's URL to buy-----------------------------------------//
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let urlString = NSURL(string: savedURL![indexPath.row] as! String)
        let url = URL(string: savedURL![indexPath.row] as! String)
        let vc = SFSafariViewController(url: url!)
        if #available(iOS 10.0, *) {
            present(vc, animated: true, completion: nil)
        } else {
            UIApplication.shared.openURL(urlString! as URL)
        }
    }
    
//------------------------------------method to delete a cell/update saved array-----------------------------------------//
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle==UITableViewCellEditingStyle.delete
        {
            savedImages?.remove(at: indexPath.row)
            savedNames?.remove(at: indexPath.row)
            savedPrices?.remove(at: indexPath.row)
            savedURL?.remove(at: indexPath.row)
            saleBool?.remove(at: indexPath.row)
            savedBrand?.remove(at: indexPath.row)
            updateUserStorage()
            tableView.reloadData()
        }
    }
    
//-----------------------------updating paging info and saved arrays-----------------------//
    
    func updateUserStorage()
    {
        let query = PFQuery(className:"storages")
        query.whereKey("user", equalTo:PFUser.current()?.username as Any)
        print(PFUser.current()?.username as Any)
        query.findObjectsInBackground {
            (objects: [PFObject]?, error: Error?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) scores.")
                // Do something with the found objects
                if let objects = objects {
                    for object in objects {
                        self.updateUserObject(object.objectId!)
                    }
                }
            } else {
                // Log details of the failure
                print("Error loading ")
            }
        }
    }
    
    //-----------------------------updtaing paging info and saved arrays helper------------------//
    
    func updateUserObject(_ id: String)
    {
        let query = PFQuery(className:"storages")
        query.getObjectInBackground(withId: id) {
            (userData: PFObject?, error: Error?) -> Void in
            if error != nil {
                print(error as Any)
            } else if let userData = userData {
                userData["savedProductImages"] = self.savedImages
                userData["savedProductNames"] = self.savedNames
                userData["savedProductURL"] = self.savedURL
                userData["savedProductPrices"] = self.savedPrices
                userData["saleBooleans"] = self.saleBool
                userData["savedBrandNames"]=self.savedBrand
                userData.saveInBackground()
            }
        }
    }
}

