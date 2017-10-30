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

class ViewController: UIViewController {
    
    // assigns the blue square to swipeLabel
    @IBOutlet weak var swipeLabel: UILabel!
    
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
        
        // testing if object can be saved into database
        let testObject = PFObject(className: "Testing")
        testObject["test"] = "clothes"
        testObject.saveInBackground { (success,error) in
            print("object Saved")
        }
        
      
        //function that assisns the gesture movement
        let swipeGesture = UIPanGestureRecognizer(target: self, action: #selector(wasDragged(gestureRecognizer:)))
        swipeLabel.addGestureRecognizer(swipeGesture)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

    
    // function that checks if card was dragged
    @objc func wasDragged(gestureRecognizer: UIPanGestureRecognizer) {
        let labelpoint = gestureRecognizer.translation(in: view)
        swipeLabel.center = CGPoint(x: view.bounds.width / 2 + labelpoint.x , y: view.bounds.height / 2 + labelpoint.y)
        
        if gestureRecognizer.state == .ended {
            if swipeLabel.center.x < (view.bounds.width / 2 - 100) {
                print("NOT Interested")
            }
            
            if swipeLabel.center.x > (view.bounds.width / 2 + 100) {
                print("Interested in clothing item")
            }
            
            swipeLabel.center = CGPoint(x: view.bounds.width/2 , y: view.bounds.height/2 )
            
        }
        
    } // end of was dragged function

    
} // end of UIviewcontrollor

