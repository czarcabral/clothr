//
//  ViewController.swift
//  clothr
//
//  Created by Czar Vince Gabriel Cabral on 10/21/17.
//  Sam Singh
//  Andrew Gu(i)terres
//  Gilbert Aragon
//  Kianna Mark
//  Christian Valdez
//
//  Copyright © 2017 cmps115. All rights reserved.
//

import UIKit
import Parse
import SVProgressHUD

var imageIndex: Int=0
var checker: NSInteger=0
var check: NSInteger=0
var productName: NSString = "men's shirt"
var products = [Any]()
var productBuffer = [Any]()
var xCenter = CGFloat(0)
var yCenter = CGFloat(0)

class ViewController: UIViewController {
    
    
    var savedImages = [Any]()
    var savedNames = [Any]()
    var savedPrices = [Any]()
    var savedURL = [Any]()
    var saleBool = [String]()
    var savedBrandNames = [Any]()
    var pagingIndex=[String: NSNumber]() //dictionary with search term as a key, paging index as value
    var searchIndex: NSNumber=0
    var bufferIndex: NSInteger=0
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var searchProduct: UIButton!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var thumbImage: UIImageView!
    
    // Initial load for swipe screen
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.show()
        searchField.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
        loadUserStorage()
        archiveFilterData()
        //updateUserStorage()
        // set the x and y variable to be equal to the center of the image
        xCenter = image.center.x
        yCenter = image.center.y
        let buffer = helperfunctions()
        buffer.fillBrandBuffer()
        buffer.fillRetailerBuffer()
        buffer.fillColorBuffer()
        
//        buffer.fillSizeBuffer()
        // hide the back button
        
        self.navigationItem.setHidesBackButton(true, animated: false)
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(showDetails(gestureRecognizer:)))
        doubleTap.numberOfTapsRequired=2
        image.addGestureRecognizer(doubleTap)
        let swipeGesture = UIPanGestureRecognizer(target: self, action: #selector(wasDragged(gestureRecognizer:)))
        image.addGestureRecognizer(swipeGesture)
    }

@objc func showDetails(gestureRecognizer: UIPanGestureRecognizer)
{
    let encodedProduct = NSKeyedArchiver.archivedData(withRootObject: products[imageIndex-1])
    let defaults = UserDefaults.standard
    defaults.set(encodedProduct, forKey: "product")
    performSegue(withIdentifier: "showDetails", sender: self)
}
    
//---------------------------load paging index and saved stuff--------------------------//
    func loadUserStorage()
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
                        self.loadUserObject(object.objectId!)
                    }
                }
            } else {
                // Log details of the failure
                print("Error loading ")
            }
            }
    }

//---------------------------grabs user paging info and saved arrays-----------------------//
    
    func loadUserObject(_ id: String)
    {
        let query = PFQuery(className:"storages")
        query.getObjectInBackground(withId: id)
        {
            (query: PFObject?, error: Error?) -> Void in
            if error != nil
            {
                print("error")
            } else if let user=query
            {
                self.savedBrandNames=user["savedBrandNames"] as! [Any]
                self.savedImages=user["savedProductImages"] as! [Any]
                self.savedNames=user["savedProductNames"] as! [Any]
                self.savedPrices=user["savedProductPrices"] as! [Any]
                self.savedURL=user["savedProductURL"] as! [Any]
                self.saleBool=user["saleBooleans"] as! [String]
                self.pagingIndex=user["pagingIndexes"] as! [String : NSNumber]
            }
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
        print("UPDATED")
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
                userData["pagingIndexes"] = self.pagingIndex
                userData["saleBooleans"] = self.saleBool
                userData["savedBrandNames"] = self.savedBrandNames
                userData.saveInBackground()
//                update
//                userData.saveEventually()
            }
        }
    }
//------------------------------------load swiping image-----------------------------------//
    
    func loadData(_ search:NSString)
    {
        image.isUserInteractionEnabled=true
        productName=search
        if let pagingCheck=pagingIndex[productName as String!]
        {
            searchIndex=pagingCheck //sets searching index to index saved in dictionary for searched product
        } else
        {
            pagingIndex[productName as String!]=0
            updateUserStorage()
        }
        imageIndex=0
        let buffer = helperfunctions()
        
        buffer.fillProductBuffer(search as String!, searchIndex)
        
        let when = DispatchTime.now() + 2
        DispatchQueue.main.asyncAfter(deadline: when) {
            if let data = UserDefaults.standard.object(forKey: "name") as? NSData {
                products = NSKeyedUnarchiver.unarchiveObject(with: data as Data) as! [Any]
            }
            if let returnedItem=products[0] as? String
            {
                if returnedItem=="overSet"                          //if the pageoffset is greater than paging index of api,
                {                                                   //then restart at index 0
                    self.pagingIndex[productName as String!]=0
                    self.loadData(productName)
                } else if returnedItem=="noItems"
                {
                    self.image.image = UIImage(named: "sorry")      //if there are no such items in a search, return a sorry
                    self.image.isUserInteractionEnabled=false       //picture disabled until is view is loaded again
                    SVProgressHUD.dismiss()
                }
            } else
            {
                self.get_image(self.image)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//---------------------------------load extra products in product array--------------------------------//

    //function is called when original array needs more objects to be added. gives an "infinite" effext
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
            products+=productBuffer
        }
    }
    
//---------------------------------get image for swiping function--------------------------------//
    func get_image(_ imageView:UIImageView)
    {
        if(imageIndex==products.count-9)
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
        
        SVProgressHUD.dismiss()
        task.resume()
        imageIndex+=1
    }
//------------------------------------function to check if pic is drag--------------------------------//
    @objc func wasDragged(gestureRecognizer: UIPanGestureRecognizer) {
        let labelpoint = gestureRecognizer.translation(in: view)
        image.center = CGPoint(x: xCenter + labelpoint.x , y: yCenter + labelpoint.y)
        
//------------------------------------function scale and drag photo--------------------------------//
        
        let xFromCenter = view.bounds.width / 2 - image.center.x
        
        //rotation and scaling
        var rotation = CGAffineTransform(rotationAngle: xFromCenter / 200)
        let scale = min(75 / abs(xFromCenter),1)
        var scaledAndRotate = rotation.scaledBy(x: scale, y: scale)
        
        image.transform = scaledAndRotate

        
 //------------------------------------adding the thumbs up or down--------------------------------//
        
        let xForThumb = image.center.x - searchProduct.center.x
        
        // dragged to right else left
        if xForThumb > 0 {
            thumbImage.image = #imageLiteral(resourceName: "thumbs-up")
            thumbImage.tintColor = UIColor.green
            
        }else {
            
            
            thumbImage.image = #imageLiteral(resourceName: "thumbs-down")
            thumbImage.tintColor = UIColor.red
        }

        thumbImage.alpha = abs(xForThumb) / image.center.x

        if gestureRecognizer.state == .ended {
            if image.center.x < (view.bounds.width / 2 - 100) {
                get_image(image)
            }
        
        //saves product details to database to be used by saved page
            if image.center.x > (view.bounds.width / 2 + 100) {
                let thisProduct: PSSProduct? = products[imageIndex-1] as? PSSProduct
                savedImages.append(thisProduct?.image.url.absoluteString as Any)
                savedNames.append(thisProduct?.name as Any)
                savedPrices.append(thisProduct?.regularPriceLabel as Any)
                savedURL.append(thisProduct?.buyURL.absoluteString as Any)
                savedBrandNames.append(thisProduct?.brand.name as Any)
                if(thisProduct?.isOnSale())!
                {
                    saleBool.append((thisProduct?.salePriceLabel)!)
                } else
                {
                    saleBool.append("-1")
                }
                checker+=1
                if imageIndex>=products.count
                {
                    imageIndex=0
                    image.image=UIImage(named: "endOfItems")
                } else
                {
                    get_image(image)
                }
            }

            // put rotation and image back to center
            rotation = CGAffineTransform(rotationAngle: 0)
            scaledAndRotate = rotation.scaledBy(x: 1, y: 1)
            image.transform = scaledAndRotate
            
            thumbImage.alpha = 0
            
            image.center = CGPoint(x: xCenter , y: yCenter)
            
            //updates the database after every swipe, just in case user terminates the app or app crashes
            if self.pagingIndex[productName as String!] == nil
            {
                self.pagingIndex[productName as String!]=0
            } else
            {
                if let currentIndex = self.pagingIndex[productName as String]?.intValue
                {
                    self.pagingIndex[productName as String] = (currentIndex + 1) as NSNumber
                }
            }
            updateUserStorage()
        }
    }
//-----------------------------------------save data for saved page--------------------------------//
    @IBAction func saveFilters(_ sender: Any) {
        updateUserStorage()
    }
    
    @IBAction func saveProducts(_ sender: Any) {
        updateUserStorage()
        encodeData()
    }
    
//-----------------------------------------encode data for saveProducts()------------------------------//
    func encodeData()
    {
        let encodedImages = NSKeyedArchiver.archivedData(withRootObject: savedImages)
        let encodedNames = NSKeyedArchiver.archivedData(withRootObject: savedNames)
        let encodedPrices = NSKeyedArchiver.archivedData(withRootObject: savedPrices)
        let encodedURL = NSKeyedArchiver.archivedData(withRootObject: savedURL)
        let encodedSales = NSKeyedArchiver.archivedData(withRootObject: saleBool)
        let encodedBrands = NSKeyedArchiver.archivedData(withRootObject: savedBrandNames)
        let defaults = UserDefaults.standard
        defaults.set(encodedImages, forKey: "images")
        defaults.set(encodedNames, forKey: "names")
        defaults.set(encodedPrices, forKey: "prices")
        defaults.set(encodedURL, forKey: "url")
        defaults.set(encodedSales, forKey: "sales")
        defaults.set(encodedBrands, forKey: "savedBrandNames")
    }

//------------------------------------------search for what user wants---------------------------------//
   
    @IBAction func searchPressed(_ sender: Any) {
        products.removeAll()
        loadData(searchField.text! as NSString)
        imageIndex=0
    }
    
//------------------------------------------search field functions---------------------------------------//

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchField.resignFirstResponder()
    }
    
    // removes the navbar
    override func viewWillAppear(_ animated: Bool) {
        SVProgressHUD.show()
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
        loadUserStorage()   //reload the user storage when returning to the page
        let when = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.loadData(productName)  //reload the page with new filters added or when returning from saved page
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
    }
    
}



//------------------------------------------extension for search field---------------------------------------//
extension ViewController : UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
        self.view.endEditing(true)
        return true
    }
    
//------------------------------------------archiving data for filters----------------------------------------//
    
    func archiveFilterData()
    {
        
        let when1 = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: when1) {
            
            
            var retailers = NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "retailer") as! Data) as? [Any]
            var brands = NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "brand") as! Data) as? [Any]
            let colors = NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "color") as! Data) as? [Any]
            
            UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: retailers as Any), forKey: "retailer")
            UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: brands as Any), forKey: "brand")
            UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: colors as Any), forKey: "color")
            var retailerCheck = [String: NSInteger]()
            var brandCheck=[String:NSInteger]()
            var colorCheck=[String: NSInteger]()
            
            
            if let list=retailers?.count    //setting up retailer dictionary for UI in filters page
            {
                for index in 0...list-1
                {
                    let retailer: PSSRetailer? = retailers![index] as? PSSRetailer
                    retailerCheck[(retailer?.name)!] = 0
                }
            }
            
            if let list=brands?.count   //setting up brand dictionary for UI in filters page
            {
                for index in 0...list-1
                {
                    let brand: PSSBrand? = brands![index] as? PSSBrand
                    brandCheck[(brand?.name)!] = 0
                }
            }
            
            if let list=colors?.count   //setting up color dictionary for UI in filters page
            {
                for index in 0...list-1
                {
                    let color: PSSColor? = colors![index] as? PSSColor
                    colorCheck[(color?.name)!] = 0
                }
            }
            
            let prices : [String] = ["0-25","25-50", "50-100", "100-150", "150-250", "250-500", "500-1000", "1000-2500", "2500-5000", "5000+"]
            UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: prices as Any), forKey: "price")
            var priceCheck = [String: NSInteger]()
            var priceIndexes=[String:NSInteger]()
            
            for index in 0...prices.count-1 //setting up dictionary for UI in filters page
            {
                priceIndexes[prices[index]]=index
                priceCheck[prices[index]]=0
            }
            
            //saving dictionaries
            UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: priceCheck as Any), forKey: "priceCheck")
            UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: retailerCheck as Any), forKey: "retailerCheck")
            UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: brandCheck as Any), forKey: "brandCheck")

            UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: colorCheck as Any), forKey: "colorCheck")
        }
        

        let pickedBrands = [String]()
        UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: pickedBrands as Any), forKey: "pickedBrands")
        let pickedRetailers=[String]()
        UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: pickedRetailers as Any), forKey: "pickedRetailers")
        let pickedPrices = [String]()
        UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: pickedPrices as Any), forKey: "pickedPrices")

        let colors = [Any]()
        UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: colors as Any), forKey: "color")
        let pickedColors = [String]()
        UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: pickedColors as Any), forKey: "pickedColors")
        
        //initialize saved filters from each filter set
        let pickedRetailerFilters=[Any]()
            UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: pickedRetailerFilters as Any), forKey: "pickedRetailerFilters")
        let pickedBrandFilters=[Any]()
        UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: pickedBrandFilters as Any), forKey: "pickedBrandFilters")
        let pickedSizeFilters=[Any]()
        UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: pickedSizeFilters as Any), forKey: "pickedPriceFilters")
        let pickedColorFilters=[Any]()
        UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: pickedColorFilters as Any), forKey: "pickedColorFilters")
        
        
    
    }
}


