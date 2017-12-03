//
//  DetailsViewController.swift
//  clothr
//
//  Created by Andrew Guterres on 11/16/17.
//  Copyright © 2017 cmps115. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    var originalCheck = false
    var imageIndex: NSInteger=0
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var whiteBackground: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var availability: UILabel!
    @IBOutlet weak var SaleCheckLabel: UILabel!
    
    @IBOutlet weak var brandLabel: UILabel!
    var product = NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "product") as! Data) as! PSSProduct
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    whiteBackground.layer.borderColor=UIColor.lightGray.cgColor
        whiteBackground.layer.borderWidth=4
        whiteBackground.layer.cornerRadius=10.5
        get_image(image)
        let changePic = UITapGestureRecognizer(target: self, action: #selector(changeImage))
        changePic.numberOfTapsRequired=1
        image.addGestureRecognizer(changePic)
        let goBack=UISwipeGestureRecognizer(target: self, action: #selector(backToSwipe(gestureRecognizer:)))
        goBack.direction=UISwipeGestureRecognizerDirection.down
        self.view.addGestureRecognizer(goBack)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//-------------------------------change the image--------------------------------------//
    
    @objc func changeImage()
    {
        get_image(image)
    }
//-------------------------------what will appear when page is opened------------------//
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
//        get_image(image)
        nameLabel.text=product.name
        brandLabel.text="Brand: " + product.brand.name
        if(product.isOnSale())
        {
            priceLabel.text=product.salePriceLabel
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: product.regularPriceLabel)
            attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
            attributeString.addAttribute(NSAttributedStringKey.strikethroughColor, value: UIColor.red, range: NSMakeRange(0, attributeString.length))
            SaleCheckLabel.attributedText = attributeString
        } else
        {
            priceLabel.text=product.regularPriceLabel
            SaleCheckLabel.text=""
        }
        
        if(product.inStock)
        {
            availability.text="In Stock"
        } else
        {
            availability.text="Not In Stock"
            availability.textColor=UIColor.red
        }
    }
    
//---------------------------------get image for detail function--------------------------------//
    func get_image(_ imageView:UIImageView)
    {
        let url = get_url(product)
        let session = URLSession.shared
        
        let task = session.dataTask(with: url, completionHandler: {
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
        imageIndex = imageIndex+1
        task.resume()
    }
    
    func get_url(_ product:PSSProduct) -> (URL)
    {
        let images=product.alternateImages
        if((images?.count)==nil)
        {
            return product.image.url //there's no alternative images
        }
        let check = images![imageIndex] as! PSSProductImage
        let check2 = images![(images?.count)!-1] as! PSSProductImage
        
        if(originalCheck==false)    //if it's the original photo
        {
            originalCheck=true
            return product.image.url
        } else if (check.url==check2.url) //if its the last in the array, circle back
        {
            imageIndex=0
            originalCheck=false
            return check2.url
        } else  //anywhere else
        {
            return check.url
        }
    }
    
//------------------------------UI functions-------------------------------//
    @objc func backToSwipe(gestureRecognizer: UISwipeGestureRecognizer)
    {
        dismiss(animated: true, completion: nil)
    }
    
}
