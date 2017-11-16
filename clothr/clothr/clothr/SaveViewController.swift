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
//    let products = UserDefaults.standard.object(forKey: "products") as! Data
    var savedImages=NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "images") as! Data) as? [Any]
    var savedNames=NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "names") as! Data) as? [Any]
    var savedPrices=NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "prices") as! Data) as? [Any]
    var savedURL=NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "url") as! Data) as? [Any]
    
    @IBOutlet weak var tableview: UITableView!
    
    var refreshControl: UIRefreshControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.delegate=self
        tableview.dataSource=self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
//------------------------------------method to get middle image for swiping page-----------------------------------------//
    func getProductImage(_ imageView:UIImageView, _ cell:SaveControllerTableViewCell, _ index: Int)
    {
//        if(savedIndex>=savedProducts!.count)
//                {
//                    savedIndex=0
//                }
//        print(savedIndex)
        //let thisProduct: PSSProduct? = savedImages![index] as? PSSProduct
        let url = NSURL(string: savedImages![index] as! String)
        let request = URLRequest(url: url! as URL)
//        print(thisProduct?.buyURL as Any)
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
//        let cell = UITableViewCell()
        //print("HI")
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SaveControllerTableViewCell
        getProductImage(cell.productImage, cell,indexPath.row)
        //let thisProduct: PSSProduct? = savedProducts![indexPath.row] as? PSSProduct
        //        print(thisProduct?.name as Any)
        cell.productPrice.text=(savedPrices?[indexPath.row] as! String)
        //print(thisProduct?.regularPriceLabel as Any)
        cell.productName.text=(savedNames?[indexPath.row] as! String)
        return(cell)
    }
    
//------------------------------------bring user to product's URL to buy-----------------------------------------//
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        //let thisProduct: PSSProduct? = savedProducts![indexPath.row] as? PSSProduct
        let urlString = NSURL(string: savedURL![indexPath.row] as! String)
        let url = URL(string: savedURL![indexPath.row] as! String)
        let vc = SFSafariViewController(url: url!)
//        present(vc, animated: true, completion: nil)
        if #available(iOS 10.0, *) {
            present(vc, animated: true, completion: nil)
//            UIApplication.shared.open((thisProduct?.buyURL)!, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(urlString! as URL)
        }
    }
    
//------------------------------------method to delete a cell/update saved array-----------------------------------------//
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle==UITableViewCellEditingStyle.delete
        {
//            print(savedImages?.count as Any)
            savedImages?.remove(at: indexPath.row)
            savedNames?.remove(at: indexPath.row)
            savedPrices?.remove(at: indexPath.row)
            savedURL?.remove(at: indexPath.row)
//            let thisProduct: PSSProduct? = savedProducts![0] as? PSSProduct
//            print(thisProduct?.name as Any)
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
                userData.saveInBackground()
            }
        }
    }
}

