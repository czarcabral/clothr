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

var imageIndex: NSInteger=0
var checker: NSInteger=0

var products = [Any]()


class SwipeViewController: UIViewController {
    
    var saved = [Any]()
    @IBOutlet weak var yourItems: UIButton!
    @IBOutlet weak var image: UIImageView!
//-----------------------------------------initial load for swipe screen--------------------------------//
    override func viewDidLoad() {
        
        //products.append("HI")
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        let buffer = helperfunctions()
        products=buffer.fillProductBuffer()
        get_image(image)
        let swipeGesture = UIPanGestureRecognizer(target: self, action: #selector(wasDragged(gestureRecognizer:)))
        image.addGestureRecognizer(swipeGesture)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
//---------------------------------get image for swiping function--------------------------------//
    func get_image(_ imageView:UIImageView)
    {
        if(imageIndex>=products.count-1)
        {
            imageIndex=0
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
//        print("HI")
        let labelpoint = gestureRecognizer.translation(in: view)
        image.center = CGPoint(x: view.bounds.width / 2 + labelpoint.x , y: view.bounds.height / 2 + labelpoint.y)
        
        if gestureRecognizer.state == .ended {
            if image.center.x < (view.bounds.width / 2 - 100) {
                print("NOT Interested")
                get_image(image)

            }

            if image.center.x > (view.bounds.width / 2 + 100) {
                print("Interested in clothing item")
                let thisProduct: PSSProduct? = products[imageIndex-1] as? PSSProduct
                saved.append(thisProduct as Any)
                if(checker>5)
                {
                    
                    for var i in (0..<checker)
                    {
                    let check: PSSProduct? = saved[i] as? PSSProduct
                    print(check?.name as Any)
                    }
                }
                checker+=1
                get_image(image)
            }

            image.center = CGPoint(x: view.bounds.width/2 , y: view.bounds.height/2 )
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
    
    
}

