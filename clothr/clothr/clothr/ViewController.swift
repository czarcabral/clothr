//
//  ViewController.swift
//  clothr
//
//  Created by Czar Vince Gabriel Cabral on 10/21/17.
//  Sam Singh
//  Andrew Gu(i)terres
//  Gilbert Aragon
//  Kianna Mark
//
//  Copyright © 2017 cmps115. All rights reserved.
//

import UIKit
import Parse

var imageIndex: NSInteger=0
var checker: NSInteger=0
var check: NSInteger=0
var productName: NSString = "men's shirt"
var products = [Any]()
var productBuffer = [Any]()
var xCenter = CGFloat(0)
var yCenter = CGFloat(0)

class ViewController: UIViewController {
    
    var saved = [Any]()
    var pagingIndex=[String: NSNumber]() //dictionary with search term as a key, paging index as value
    var searchIndex: NSNumber=0
    var bufferIndex: NSInteger=0
   
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var searchProduct: UIButton!
    @IBOutlet weak var searchField: UITextField!
    
    //-----------------------------------------initial load for swipe screen--------------------------------//
    override func viewDidLoad() {
        
        //products.append("HI")
        super.viewDidLoad()
        searchField.delegate=self
        pagingIndex[productName as String!]=0
        // Do any additional setup after loading the view, typically from a nib.
        
        loadData(productName)
        print(productName)
//        let thisProduct: PSSProduct? = products[imageIndex] as? PSSProduct
//        print("viewdidLoad: " + (thisProduct?.name)! as Any)
        
        // set the x and y variable to be equal to the center of the image
        xCenter = image.center.x
        yCenter = image.center.y
        
        // hide the back button
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        let swipeGesture = UIPanGestureRecognizer(target: self, action: #selector(wasDragged(gestureRecognizer:)))
        image.addGestureRecognizer(swipeGesture)
    }
    
//------------------------------------load swiping image-----------------------------------//
    
    func loadData(_ search:NSString)
    {
        productName=search
        if let pagingCheck=pagingIndex[productName as String!]
        {
            print("paging check: ")
            print(pagingCheck)
            searchIndex=pagingCheck //sets searching index to index saved in dictionary for searched product
        } else
        {
            pagingIndex[productName as String!]=0
        }
        print("Search index: ")
        print(searchIndex)
        let buffer = helperfunctions()
        
        buffer.fillProductBuffer(search as String!, searchIndex)
        
        let when = DispatchTime.now() + 2
        DispatchQueue.main.asyncAfter(deadline: when) {
            if let data = UserDefaults.standard.object(forKey: "name") as? NSData {
                products = NSKeyedUnarchiver.unarchiveObject(with: data as Data) as! [Any]
            }
            let thisProduct: PSSProduct? = products[imageIndex] as? PSSProduct
            print("loadData: " + (thisProduct?.name)! as Any)
            self.get_image(self.image)
        }
        //        print("loadData: " + (thisProduct?.name)! as Any)
        //        get_image(image)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//---------------------------------load extra products in product array--------------------------------//

    func loadExtraBuffer(_ search: NSString)
    {
        productName=search
        if let pagingCheck=pagingIndex[productName as String!]
        {
            searchIndex = (pagingCheck.intValue+searchIndex.intValue+10) as NSNumber
        }
        
        let buffer = helperfunctions()
        
        buffer.fillProductBuffer(search as String!, searchIndex)
        
        let when = DispatchTime.now() + 2
        DispatchQueue.main.asyncAfter(deadline: when) {
            if let data = UserDefaults.standard.object(forKey: "name") as? NSData {
                productBuffer = NSKeyedUnarchiver.unarchiveObject(with: data as Data) as! [Any]
            }
//            let thisProduct: PSSProduct? = products[products.count-1] as? PSSProduct
//            print("loadData: " + (thisProduct?.name)! as Any)
//            print(productBuffer.count)
            products+=productBuffer
//            print(products.count)
        }
    }
    
//---------------------------------get image for swiping function--------------------------------//
    func get_image(_ imageView:UIImageView)
    {
        if(imageIndex==products.count-5)
        {
            //imageIndex=0
            loadExtraBuffer(productName)
        }
        let thisProduct: PSSProduct? = products[imageIndex] as? PSSProduct
        let url = thisProduct?.image.url
        let session = URLSession.shared
        
        let task = session.dataTask(with: url!, completionHandler: {
            (
            data, response, error) in
            if data != nil
            {
                let image = UIImage(data: data!)
                if(image != nil)
                {
                    DispatchQueue.main.async(execute: {
                        imageView.image = image
                        imageView.contentMode = .scaleAspectFit
                    })
                }
            }
        })
        
        task.resume()
        imageIndex+=1
    }
//------------------------------------function to check if pic is drag--------------------------------//
    @objc func wasDragged(gestureRecognizer: UIPanGestureRecognizer) {
        let labelpoint = gestureRecognizer.translation(in: view)
        image.center = CGPoint(x: xCenter + labelpoint.x , y: yCenter + labelpoint.y)
        
        if gestureRecognizer.state == .ended {
            if image.center.x < (view.bounds.width / 2 - 100) {
                print("NOT Interested")
                get_image(image)

            }

            if image.center.x > (view.bounds.width / 2 + 100) {
                print("Interested in clothing item")
                let thisProduct: PSSProduct? = products[imageIndex-1] as? PSSProduct
                saved.append(thisProduct as Any)
                checker+=1
                get_image(image)
            }

            image.center = CGPoint(x: xCenter , y: yCenter)
        }
    }
//-----------------------------------------encode data for saved page--------------------------------//

    @IBAction func saveProducts(_ sender: Any) {
        //let thisProduct: PSSProduct? = saved[0] as? PSSProduct
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: saved)
        let defaults = UserDefaults.standard
        defaults.set(encodedData, forKey: "products")
        print("saved")
    }

//------------------------------------------search for what user whats---------------------------------//
   
    @IBAction func searchPressed(_ sender: Any) {
        products.removeAll()
        
        print(pagingIndex[productName as String] as Any)
        pagingIndex[productName as String] = Int(truncating: pagingIndex[productName as String]!) + imageIndex as NSNumber  //saves the previous paging offset
        //pagingIndex[productName as String] = pagingIndex[productName as String]?.intValue + imageIndex  //saves the previous paging offset
        print(pagingIndex[productName as String] as Any)
        
        //        print(pagingIndex[searchField.text as! String] as Any)
        //            imageIndex=0
        //            products.removeAll()
        //        DispatchQueue.main.async(execute: {
        loadData(searchField.text! as NSString)
        //        })
        imageIndex=0
        
        let when = DispatchTime.now() + 2 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            //loadData(searchField.text! as NSString)
            let thisProduct: PSSProduct? = products[imageIndex] as? PSSProduct
            print("searchPressed: " + (thisProduct?.name)! as Any)
            //productName=searchField.text! as NSString
            //self.get_image(self.image)
        }
    
       
    }
    
//------------------------------------------search field functions---------------------------------------//

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchField.resignFirstResponder()
    }

//------------------------------------------log out button function---------------------------------------//
    @IBAction func logOutPressed(_ sender: Any) {
        // show user logged in
        // print("current user: ", PFUser.current() as Any)
        
        // log user out, PFUser.current() = nil
        PFUser.logOut()
        _ = PFUser.current()
        
        // check user is logged out
        // print("user: ", PFUser.current() as Any)
        
        // go to home page after logging out
        guard (navigationController?.popToRootViewController(animated: true)) != nil
            else {
                print("No View Controller to Pop")
                return
        }
    }
}

//------------------------------------------extension for search field---------------------------------------//
extension ViewController : UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

