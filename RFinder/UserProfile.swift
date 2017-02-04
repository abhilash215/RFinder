//
//  UserProfile.swift
//  RFinder
//
//  Created by abhilash uday on 11/29/16.
//  Copyright © 2016 AbhilashSU. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import FBSDKLoginKit

class UserProfile: UIViewController, FBSDKLoginButtonDelegate{
    
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var ivUserProfileImage: UIImageView!
    @IBOutlet var btnFacebook: FBSDKLoginButton!
    @IBOutlet var btnFirebaseLogOut: UIButton!
    var window: UIWindow?
    let ref:FIRDatabaseReference! = nil
    var urlImage : String!
    var databaseRef: FIRDatabaseReference! {
        return FIRDatabase.database().reference()
    }
    
    var storageRef: FIRStorage! {
        return FIRStorage.storage()
    }
    
    override func viewWillAppear(animated: Bool) {
       
        
        self.btnFirebaseLogOut.setTitle("Log out", forState: .Normal)
        self.btnFirebaseLogOut.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    }
    
    override func viewDidAppear(animated:  Bool) {
         self.view.makeToast("Your profile",duration: 2.0, position: .center)
    }
    

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let bgColor = UIColor(red:0.15, green:0.14, blue:0.22, alpha:1.0)
        self.view.backgroundColor = bgColor
        let btnColor = UIColor(red:1.00, green:0.20, blue:0.20, alpha:0.6)
        self.btnFirebaseLogOut.backgroundColor = btnColor
        self.btnFirebaseLogOut.layer.cornerRadius = 10
        self.btnFirebaseLogOut.layer.borderWidth = 0.5
        self.btnFirebaseLogOut.layer.borderColor = UIColor.whiteColor().CGColor
         self.btnFirebaseLogOut.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        configureFacebook()
       
    }
    
    // func firebase logout
    @IBAction func btnFirebaseLogOutPressed(sender: AnyObject){
        
        SweetAlert().showAlert("Are you sure?", subTitle: "You will be logged out!", style: AlertStyle.warning, buttonTitle:"No", buttonColor:UIColor.colorFromRGB(0xD0D0D0) , otherButtonTitle:  "Yes", otherButtonColor: UIColor.colorFromRGB(0xDD6B55)) { (isOtherButton) -> Void in
            if isOtherButton == true {
                
                
            }
            else {
                self.lblName.text = ""
                try! FIRAuth.auth()!.signOut()
                self.performSegueWithIdentifier("backtologinidentifier", sender: self)
            }
        }
        
        
    }
    
    //fetch data from FB
    func facebookfetch() {
        let fbLoginManager: FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logInWithReadPermissions(["public_profile","email","user_friends"], fromViewController: self, handler: {(result,error)->Void in
            if(error == nil){
                let fbloginResult: FBSDKLoginManagerLoginResult = result
                if(fbloginResult.grantedPermissions.contains("email")){
                    self.getFBUserData()
                }else{
                    print("not granted permission")
                }
            }
        })
    }
    
    func getFBUserData(){
        if((FBSDKAccessToken.currentAccessToken()) != nil){
            FBSDKGraphRequest(graphPath: "me",parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).startWithCompletionHandler({(connection,result,error)-> Void in
                if (error == nil){
                    let strFirstName: String = (result.objectForKey("first_name") as? String)!
                    let strLastName: String = (result.objectForKey("last_name") as? String)!
                    let strPictureURL: String = (result.objectForKey("picture")?.objectForKey("data")?.objectForKey("url") as? String)!
                    
                    self.lblName.text = "Welcome, \(strFirstName) \(strLastName)"
                    self.lblName.textColor = UIColor.whiteColor()
                    self.ivUserProfileImage.image = UIImage(data: NSData(contentsOfURL: NSURL(string: strPictureURL)!)!)
                }
                
            })
        }
    }

    
    //    MARK: FBSDKLoginButtonDelegate Methods
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!)
    {
        
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!)
    {
        
                        fbLogin = false
                self.ivUserProfileImage.image = UIImage(named: "imgUserLogo")
                self.lblName.text = ""
                let loginManager: FBSDKLoginManager = FBSDKLoginManager()
                loginManager.logOut()
                self.performSegueWithIdentifier("backtologinidentifier", sender: self)
        
        
       
        
    }
    
    //    MARK: Other Methods
    
    func configureFacebook()
    {
       btnFacebook.readPermissions = ["public_profile", "email", "user_friends"];
       btnFacebook.delegate = self
        if(FBSDKAccessToken.currentAccessToken() != nil){
            btnFirebaseLogOut.hidden = true
            facebookfetch()
        }else{
            
            //
            
            databaseRef.child("users/\(FIRAuth.auth()!.currentUser!.uid)").observeEventType(.Value, withBlock: { (snapshot) in
                dispatch_async(dispatch_get_main_queue(), {
                    
                    if !snapshot.exists() { return }
                    
                    //print(snapshot)
                    
                    if let username = snapshot.value!["username"] as? String {
                        self.lblName.text = "Welcome, \(username)"
                        self.lblName.textColor = UIColor.whiteColor()
                    }
                    if let imageUrl = snapshot.value!["photoUrl"] as? String{
                        self.storageRef.referenceForURL(imageUrl).dataWithMaxSize(1 * 1024 * 1024, completion: { (data, error) in
                            
                            if let error = error {
                                print(error.localizedDescription)
                            }else {
                                if let data = data {
                                    self.ivUserProfileImage.image = UIImage(data: data)
                                }
                            }
                        })
                    }
                    
                })
                
                
            }) { (error) in
                print(error.localizedDescription)
            }
            
            
            //
            
            btnFacebook.hidden = true
          

        }
        
    }
    
}
