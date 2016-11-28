//
//  LoginViewController.swift
//  RFinder
//
//  Created by abhilash uday on 11/27/16.
//  Copyright © 2016 AbhilashSU. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class LoginViewController:UIViewController {
    
    @IBOutlet weak var passwordtextfield: UITextField!
    @IBOutlet weak var emailtextfield: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad() 
    }

    
    @IBAction func LogIn (){
        
        let email=self.emailtextfield.text
        let password=self.passwordtextfield.text
        if(email != "" && password != ""){
            
            print(" logging in ")
//            let FIREBASE_REF = Firebase(url: BASE_URL)
//
//            FIREBASE_REF.authUser(email, password: password, withCompletionBlock: { error, authData in
//                
//                if error == nil
//                {
//                    NSUserDefaults.standardUserDefaults().setValue(authData.uid, forKey: "uid")
//                    print("Logged In :)")
//                    self.logoutButton.hidden = false
//                }
//                else
//                {
//                    print(error)
//                }
//            })
    
            
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
