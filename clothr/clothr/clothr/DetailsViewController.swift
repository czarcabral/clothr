//
//  DetailsViewController.swift
//  clothr
//
//  Created by Andrew Guterres on 11/16/17.
//  Copyright © 2017 cmps115. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var whiteBackground: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var availability: UILabel!
    @IBOutlet weak var SaleCheckLabel: UILabel!
    var product = NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "product") as! Data) as! PSSProduct
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        whiteBackground.layer.borderColor=UIColor.lightGray.cgColor
        whiteBackground.layer.borderWidth=4
        whiteBackground.layer.cornerRadius=10.5
        let goBack=UISwipeGestureRecognizer(target: self, action: #selector(backToSwipe(gestureRecognizer:)))
        goBack.direction=UISwipeGestureRecognizerDirection.down
        self.view.addGestureRecognizer(goBack)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
//-------------------------------what will appear when page is opened------------------//
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
        get_image(image)
        nameLabel.text=product.name
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
//            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: "In Stock")
//            attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
//            attributeString.addAttribute(NSAttributedStringKey.strikethroughColor, value: UIColor.red, range: NSMakeRange(0, attributeString.length))
//            availability.attributedText = attributeString
        } else
        {
            availability.text="Not In Stock"
            availability.textColor=UIColor.red
        }
    }
    
//---------------------------------get image for detail function--------------------------------//
    func get_image(_ imageView:UIImageView)
    {
        let thisProduct=product
        let url = thisProduct.image.url
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
    }
    
//------------------------------UI functions-------------------------------//
    @objc func backToSwipe(gestureRecognizer: UISwipeGestureRecognizer)
    {
        dismiss(animated: true, completion: nil)
    }
    
}
