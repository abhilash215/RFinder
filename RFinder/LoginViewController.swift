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
import FirebaseDatabase
import FBSDKLoginKit


var fbLogin = false
class LoginViewController:UIViewController, FBSDKLoginButtonDelegate,UITextFieldDelegate{
    
    @IBOutlet weak var createActBtn: UIButton!
    @IBOutlet weak var logInBtn: UIButton!
    @IBOutlet weak var forgotPassword: UIButton!
    @IBOutlet weak var passwordtextfield: B68UIFloatLabelTextField!
    @IBOutlet weak var emailtextfield: B68UIFloatLabelTextField!
    @IBOutlet weak var fbLoginBtn:FBSDKLoginButton!
    var ref: FIRDatabaseReference!
    
    // firebase forgot password
      @IBAction func forgotPasswordPressed(sender:AnyObject){
        var alertController:UIAlertController?
        alertController = UIAlertController(title: "Reset your password", message: "Enter your email id to reset the password", preferredStyle: .Alert)
        alertController!.addTextFieldWithConfigurationHandler({(textField:UITextField!) in
            textField.placeholder = "Email id"})
        
        let action = UIAlertAction(title: "Submit",
                                   style:UIAlertActionStyle.Default,
                                   handler: {[weak self]
                                    (paramAction: UIAlertAction!)in
                                    if let textFields = alertController?.textFields{
                                        let theTextFields = textFields as [UITextField]
                                        theTextFields[0].delegate = self
                                        let enteredText = theTextFields[0].text
                                        FIRAuth.auth()?.sendPasswordResetWithEmail(enteredText!, completion: {(error) in
                                            if error == nil {
                                                SweetAlert().showAlert("Success!", subTitle: "Link is sent to your mail", style: AlertStyle.success)
                                            }else{
                                                SweetAlert().showAlert("Error!", subTitle: "Please check the email entered", style: AlertStyle.error)
                                            }
                                            
                                        })
                                    }
            })
        
        alertController?.addAction(action)
        self.presentViewController(alertController!,animated:true,completion:nil)
    }
    
    func getFBUserData(){
        if((FBSDKAccessToken.currentAccessToken()) != nil){
            FBSDKGraphRequest(graphPath: "me",parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).startWithCompletionHandler({(connection,result,error)-> Void in
                if (error == nil){
                    print(result)
                }
            
        })
        }
    }
      override func viewDidLoad() {
        super.viewDidLoad()
        ref = FIRDatabase.database().reference()
        let bgColor = UIColor(red:0.15, green:0.14, blue:0.22, alpha:1.0)
        self.view.backgroundColor = bgColor
        emailtextfield.delegate = self
        passwordtextfield.delegate = self
       
        emailtextfield.attributedPlaceholder = NSAttributedString(string:"Email Id",
                                                               attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        passwordtextfield.attributedPlaceholder = NSAttributedString(string:"Password",
                                                               attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        
        let btnColor = UIColor(red:1.00, green:0.20, blue:0.20, alpha:0.6)
        emailtextfield.activeTextColorfloatingLabel = UIColor(red:0.82, green:0.29, blue:0.35, alpha:1)
        emailtextfield.textColor = UIColor(red:0.82, green:0.29, blue:0.35, alpha:1)
        passwordtextfield.textColor = UIColor(red:0.82, green:0.29, blue:0.35, alpha:1)
        passwordtextfield.activeTextColorfloatingLabel = UIColor(red:0.82, green:0.29, blue:0.35, alpha:1)
        emailtextfield.inactiveTextColorfloatingLabel = UIColor.whiteColor()
        passwordtextfield.inactiveTextColorfloatingLabel = UIColor.whiteColor()
        self.forgotPassword.backgroundColor = btnColor
        self.logInBtn.backgroundColor = btnColor
        self.logInBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        
        self.createActBtn.backgroundColor = btnColor
        self.forgotPassword.layer.cornerRadius = 10
        self.forgotPassword.layer.borderWidth = 0.5
        self.forgotPassword.layer.borderColor = UIColor.whiteColor().CGColor
        self.forgotPassword.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        
        self.logInBtn.layer.cornerRadius = 10
        self.logInBtn.layer.borderWidth = 0.5
        self.logInBtn.layer.borderColor = UIColor.whiteColor().CGColor
        self.fbLoginBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.createActBtn.layer.cornerRadius = 10
        self.createActBtn.layer.borderWidth = 0.5
        self.createActBtn.layer.borderColor = UIColor.whiteColor().CGColor
        self.fbLoginBtn.readPermissions = ["public_profile", "email", "user_friends"]
        self.fbLoginBtn.delegate = self
        self.createActBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        
    }
    
    //FB logout
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
        if(error == nil)
        {
            fbLogin = true
            self.performSegueWithIdentifier("tabbaridentifier", sender: self)
        }
        else
        {
            print("Credentials do not match")
            self.emailtextfield.text = ""
            self.passwordtextfield.text = ""
            let alert = UIAlertController(title: "Error", message: "Email and Password do not match. Please try again.", preferredStyle: UIAlertControllerStyle.Alert)
            let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
            alert.addAction(action)
        }
        
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        fbLogin = false
        print("user did logout")
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        textField.resignFirstResponder()
        return true;
    }

    
    
    @IBAction func registerToApp(){
        passwordtextfield.resignFirstResponder()
        emailtextfield.resignFirstResponder()
        self.performSegueWithIdentifier("registeridentifier", sender: self)
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        passwordtextfield.resignFirstResponder()
        emailtextfield.resignFirstResponder()
    }
    
    
    //Firebase log in
    @IBAction func LogIn (){
        passwordtextfield.resignFirstResponder()
        emailtextfield.resignFirstResponder()
        let email=self.emailtextfield.text
        let password=self.passwordtextfield.text

        if(email != "" && password != ""){
            FIRAuth.auth()?.signInWithEmail(email!, password: password!, completion: {
               user,error in
                
                if(error == nil)
                {
                    
                    
                    let favRef = self.ref.child("users").child((user?.uid)!) 
                    
                    favRef.observeEventType(.Value, withBlock: { snapshot in
                        
                        if !snapshot.exists() { return }
    
                        
                        if let favArray = snapshot.value!["FavRes"] as? [String] {
                            
                            self.ref.child("users").child(user!.uid).child("FavRes").setValue(favArray)
                            favRestArray = favArray
                        }else{
                            self.ref.child("users").child(user!.uid).child("FavRes").setValue("")
                        }
                        
                   
                    })
                    self.performSegueWithIdentifier("tabbaridentifier", sender: self)
                    
                }
                    
                else
                {
                    print("Credentials do not match")
                    SweetAlert().showAlert("Error!", subTitle: "Email and passwords do not match", style: AlertStyle.error)
                    
                    self.passwordtextfield.text = ""
                }
            })
        }
            
        else
        {
            SweetAlert().showAlert("Error!", subTitle: "Email and passwords do not match", style: AlertStyle.error)
            }
                
    }
   
}
