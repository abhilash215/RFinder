//
//  Createaccount.swift
//  RFinder
//
//  Created by abhilash uday on 11/27/16.
//  Copyright © 2016 AbhilashSU. All rights reserved.
//

import UIKit
import Firebase

class Createaccount: UIViewController {
    
   // var rootRef = Firebase(url:"https://<YOUR-FIREBASE-APP>.firebaseio.com")
   // let FIREBASE_URL = Firebase (url : BASE_URL)
    
    
    @IBOutlet weak var passwordtextfield: UITextField!
    @IBOutlet weak var emailtextfiled: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
}

    @IBAction func Cancel(sender: AnyObject) {
        emailtextfiled.text = ""
        passwordtextfield.text = ""
        
        
    }
    
    
    @IBAction func create(sender: AnyObject) {
        
        let email = self.emailtextfiled.text
        let password = self.passwordtextfield.text
        if(email != "" && password != ""){
            
        }
        
        else
        {
            let alert = UIAlertController(title: "Error", message: "Enter Email and Password.", preferredStyle: UIAlertControllerStyle.Alert)
            let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
    }
    
}
