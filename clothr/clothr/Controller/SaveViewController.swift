//
//  SaveController.swift
//  clothr
//
//  Created by Andrew Guterres on 10/30/17.
//  Copyright © 2017 cmps115. All rights reserved.
//

import UIKit
var savedIndex: NSInteger=0
var checker2: NSInteger=5



class SaveViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let vc = SwipeViewController()
//    let products = UserDefaults.standard.object(forKey: "products") as! Data
    let savedProducts=NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "products") as! Data) as? [Any]

    @IBOutlet weak var tableview: UITableView!
    
    var refreshControl: UIRefreshControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.delegate=self
        tableview.dataSource=self
//        let products = UserDefaults.standard.object(forKey: "products") as! Data
//        let savedProducts=NSKeyedUnarchiver.unarchiveObject(with: products) as? [Any]
//        for var i in (0..<2)
//        {
//            print(products[i])
//        }
//        let thisProduct: PSSProduct? = savedProducts![0] as? PSSProduct
//        print(thisProduct?.salePriceLabel as Any)
//        print(savedProducts.name as Any)
//        for var i in (0..<checker2)
//        {
//            let check: PSSProduct? = vc.saved[i] as? PSSProduct
//            print(check?.name as Any)
//        }
//        // Do any additional setup after loading the view.
//        refreshControl = UIRefreshControl()
////        refreshControl.attributedTitle = NSAttributedString(string:" ")
//        refreshControl.addTarget(self, action: #selector(SaveViewController.populate), for: UIControlEvents.valueChanged)
//        tableView.addSubview(refreshControl)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
//------------------------------------method to get middle image for swiping page--------------------------------------------//
    func getProductImage(_ imageView:UIImageView, _ cell:SaveControllerTableViewCell, _ index: Int)
    {
//        if(savedIndex>=savedProducts!.count)
//                {
//                    savedIndex=0
//                }
//        print(savedIndex)
        let thisProduct: PSSProduct? = savedProducts![index] as? PSSProduct
        let url = thisProduct?.image.url
        let session = URLSession.shared
        
        let task = session.dataTask(with: url!, completionHandler: {
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
        return savedProducts!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = UITableViewCell()
        //print("HI")
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SaveControllerTableViewCell
        getProductImage(cell.productImage, cell,indexPath.row)
        let thisProduct: PSSProduct? = savedProducts![indexPath.row] as? PSSProduct
        //        print(thisProduct?.name as Any)
        cell.productPrice.text=thisProduct?.regularPriceLabel
        print(thisProduct?.regularPriceLabel as Any)
        cell.productName.text=thisProduct?.name
            
        
        return(cell)
    }
}

