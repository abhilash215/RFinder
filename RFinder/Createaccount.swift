//
//  Createaccount.swift
//  RFinder
//
//  Created by abhilash uday on 11/27/16.
//  Copyright © 2016 AbhilashSU. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class Createaccount: UIViewController ,UIImagePickerControllerDelegate,UINavigationControllerDelegate, UIPickerViewDelegate,UITextFieldDelegate{
    
    @IBOutlet weak var createActBtn: UIButton!
    @IBOutlet weak var passwordtextfield: B68UIFloatLabelTextField!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var emailtextfiled: B68UIFloatLabelTextField!
    @IBOutlet weak var usernamefield:B68UIFloatLabelTextField!
    @IBOutlet weak var userImageView: UIImageView!
    
    var storageRef: FIRStorageReference {
        return FIRStorage.storage().reference()
    }
    var databaseRef: FIRDatabaseReference! {
        return FIRDatabase.database().reference()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(Createaccount.choosePicture(_:)))
        userImageView.addGestureRecognizer(tapGesture)
        
        let bgColor = UIColor(red:0.15, green:0.14, blue:0.22, alpha:1.0)
        self.view.backgroundColor = bgColor
        emailtextfiled.delegate = self
        passwordtextfield.delegate = self
        usernamefield.delegate = self
        
        emailtextfiled.attributedPlaceholder = NSAttributedString(string:"Email Id",
                                                                  attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        passwordtextfield.attributedPlaceholder = NSAttributedString(string:"Password",
                                                                     attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        usernamefield.attributedPlaceholder = NSAttributedString(string:"User Name",
                                                                     attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        
        let btnColor = UIColor(red:1.00, green:0.20, blue:0.20, alpha:0.6)
        emailtextfiled.activeTextColorfloatingLabel = UIColor(red:0.82, green:0.29, blue:0.35, alpha:1.0)
        emailtextfiled.textColor = UIColor(red:0.82, green:0.29, blue:0.35, alpha:1.0)
        usernamefield.textColor = UIColor(red:0.82, green:0.29, blue:0.35, alpha:1.0)
        passwordtextfield.textColor = UIColor(red:0.82, green:0.29, blue:0.35, alpha:1.0)
        usernamefield.activeTextColorfloatingLabel = UIColor(red:0.82, green:0.29, blue:0.35, alpha:1.0)
        passwordtextfield.activeTextColorfloatingLabel = UIColor(red:0.82, green:0.29, blue:0.35, alpha:1.0)
        emailtextfiled.inactiveTextColorfloatingLabel = UIColor.whiteColor()
        passwordtextfield.inactiveTextColorfloatingLabel = UIColor.whiteColor()
        usernamefield.inactiveTextColorfloatingLabel = UIColor.whiteColor()
        
        self.cancelBtn.backgroundColor = btnColor
        self.createActBtn.backgroundColor = btnColor
        
        
        self.cancelBtn.layer.cornerRadius = 10
        self.cancelBtn.layer.borderWidth = 0.5
        self.cancelBtn.layer.borderColor = UIColor.whiteColor().CGColor
        
        self.createActBtn.layer.cornerRadius = 10
        self.createActBtn.layer.borderWidth = 0.5
        self.createActBtn.layer.borderColor = UIColor.whiteColor().CGColor

        
    }

    //func to cancel sign up
    @IBAction func Cancel(sender: AnyObject) {
        passwordtextfield.resignFirstResponder()
        emailtextfiled.resignFirstResponder()
        emailtextfiled.text = ""
        passwordtextfield.text = ""
        self.performSegueWithIdentifier("Loginidentifier", sender: self)
    }
    
    
    func choosePicture(gesture:UITapGestureRecognizer) {
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        
        let alertController = UIAlertController(title: "Add a Picture", message: "Choose From", preferredStyle: .ActionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .Default) { (action) in
            pickerController.sourceType = .Camera
            self.presentViewController(pickerController, animated: true, completion: nil)
            
        }
        let photosLibraryAction = UIAlertAction(title: "Photos Library", style: .Default) { (action) in
            pickerController.sourceType = .PhotoLibrary
            self.presentViewController(pickerController, animated: true, completion: nil)
            
        }
        
        let savedPhotosAction = UIAlertAction(title: "Saved Photos Album", style: .Default) { (action) in
            pickerController.sourceType = .SavedPhotosAlbum
            self.presentViewController(pickerController, animated: true, completion: nil)
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Destructive, handler: nil)
        
        alertController.addAction(cameraAction)
        alertController.addAction(photosLibraryAction)
        alertController.addAction(savedPhotosAction)
        alertController.addAction(cancelAction)
        
        
        presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        self.dismissViewControllerAnimated(true, completion: nil)
        self.userImageView.image = image
    }
    
    
    //func to tapgesture of keyboard
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        passwordtextfield.resignFirstResponder()
        emailtextfiled.resignFirstResponder()
        usernamefield.resignFirstResponder()
    }
    
    private func saveInfo(user: FIRUser!, username: String, password: String){
        
        // Create our user dictionary info\
        
        let userInfo = ["email": user.email!, "username": username, "photoUrl": String(user.photoURL!),"FavRes":""]
        
        // create user reference
        
        let userRef = databaseRef.child("users").child(user.uid)
        
        // Save the user info in the Database
        
        userRef.setValue(userInfo)
        
    }

    
    
    private func setUserInfo(user: FIRUser!, username: String, password: String, data: NSData!){
        
        //Create Path for the User Image
        let imagePath = "profileImage\(user.uid)/userPic.jpg"
        
        
        // Create image Reference
        
        let imageRef = storageRef.child(imagePath)
        
        // Create Metadata for the image
        
        let metaData = FIRStorageMetadata()
        metaData.contentType = "image/jpeg"
        
        // Save the user Image in the Firebase Storage File
        
        imageRef.putData(data, metadata: metaData) { (metaData, error) in
            if error == nil {
                
                let changeRequest = user.profileChangeRequest()
                changeRequest.displayName = username
                changeRequest.photoURL = metaData!.downloadURL()
                changeRequest.commitChangesWithCompletion({ (error) in
                    
                    if error == nil {
                        
                        self.saveInfo(user, username: username, password: password)
                        
                    }else{
                        print(error!.localizedDescription)
                        
                    }
                })
                
                
            }else {
                print(error!.localizedDescription)
                
            }
        }
        
        
        
        
        
    }

    
    //create account
    @IBAction func create(sender: AnyObject) {
        let data = UIImageJPEGRepresentation(self.userImageView.image!, 0.8)
        passwordtextfield.resignFirstResponder()
        emailtextfiled.resignFirstResponder()
        let email = self.emailtextfiled.text
        let password = self.passwordtextfield.text
        let username = self.usernamefield.text
        if(email != "" && password != ""){
            
            if(password?.characters.count < 6){
                /*let alert = UIAlertController(title: "Error", message: "Password must be at least 6 characters ", preferredStyle: UIAlertControllerStyle.Alert)
                let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
                alert.addAction(action)
                self.presentViewController(alert, animated: true, completion: nil)*/
                
                SweetAlert().showAlert("Error!", subTitle: "Password must be at least 6 characters ", style: AlertStyle.error)
                
            }
            else
            {
            FIRAuth.auth()?.createUserWithEmail(email!, password: password!, completion: {
                user,error in
                if(error == nil){
                    self.setUserInfo(user, username: username!, password: password!, data: data)
                    
                    let alert = UIAlertController(title: "Account Created", message: "You May now Login.", preferredStyle: UIAlertControllerStyle.Alert)
                    let action = UIAlertAction(title: "Ok", style: .Default, handler: {action in
                        self.performSegueWithIdentifier("Loginidentifier", sender: self)
                    })
                    alert.addAction(action)
                    self.presentViewController(alert, animated: true, completion: nil)
                    print("created")
                    
                    
                    
                }
                else
                {
                    print(error)
                    SweetAlert().showAlert("Error!", subTitle: "Please check the entered Email and Password", style: AlertStyle.error)
                }
            })
        }
    }
        
        else
        {
            SweetAlert().showAlert("Error!", subTitle: "Please enter Email and Password", style: AlertStyle.error)
            
            
        }
        
    }
    
}
