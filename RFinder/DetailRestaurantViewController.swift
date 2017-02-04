//
//  DetailRestaurantViewController.swift
//  RFinder
//
//  Created by Rakesh N E on 12/1/16.
//  Copyright © 2016 AbhilashSU. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import FirebaseDatabase
import FirebaseAuth

var favRestArray = [String]()
class DetailRestaurantViewController:UIViewController{
    @IBOutlet weak var restaurantName: UILabel!
    @IBOutlet weak var open24hrs:UILabel!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var address:UILabel!
    @IBOutlet weak var cuisine:UILabel!
    @IBOutlet weak var phoneNum:UILabel!
    @IBOutlet weak var website:UILabel!
    @IBOutlet weak var mapView:MKMapView!
    var ref: FIRDatabaseReference!
    var restaurant:Restaurant?
    
    @IBAction func addtofav(sender: AnyObject) {
        
        SweetAlert().showAlert("Are you sure?", subTitle: "This restaurant will be added to your Favorites!", style: AlertStyle.warning, buttonTitle:"No", buttonColor:UIColor.colorFromRGB(0xD0D0D0) , otherButtonTitle:  "Yes", otherButtonColor: UIColor.colorFromRGB(0xDD6B55)) { (isOtherButton) -> Void in
            if isOtherButton == true {
                
                SweetAlert().showAlert("Cancelled!", subTitle: "Restaurant is not added to favorites", style: AlertStyle.error)
            }
            else {
                let user = FIRAuth.auth()?.currentUser
                let emailid = user?.email
                let userid = FIRAuth.auth()?.currentUser?.uid
                let favRestNLoc = (self.restaurant?.name)!+"+"+(self.restaurant?.location)!
                favRestArray.append(favRestNLoc)
                self.storePostsToDB(emailid, userID: userid)
     
            }
        }
        
        
    }
    
    func storePostsToDB(emailid :String!, userID : String!){
   let parentRef = FIRDatabase.database().reference().child("users").child(userID).child("FavRes")
        parentRef.setValue(favRestArray)
        
        SweetAlert().showAlert("Success!", subTitle: "Restaurant is added to favorites", style: AlertStyle.success)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if fbLogin == true{
            saveBtn.hidden = true
        }
        
        let bgColor = UIColor(red:0.15, green:0.14, blue:0.22, alpha:1.0)
        self.view.backgroundColor = bgColor
        let btnColor = UIColor(red:1.00, green:0.20, blue:0.20, alpha:0.6)
        self.saveBtn.backgroundColor = btnColor
        self.saveBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.saveBtn.layer.cornerRadius = 10
        self.saveBtn.layer.borderWidth = 0.5
        self.saveBtn.layer.borderColor = UIColor.whiteColor().CGColor
        
        if let restaurant = self.restaurant {
            let location = CLLocationCoordinate2DMake(Double(restaurant.latitude)!, Double(restaurant.longitude)!)
            
            // Create an annotation for the restaurant
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            annotation.title = restaurant.address
            mapView.selectAnnotation(annotation, animated: true)
            mapView.addAnnotation(annotation)
            // Display a small region around the annotation
            let span = MKCoordinateSpanMake(0.006, 0.006)
            let region = MKCoordinateRegionMake(location, span)
            mapView.setRegion(region, animated: true)
            restaurantName.text = restaurant.name
            restaurantName.textColor = UIColor.whiteColor()
            if(restaurant.open24hrs == 0){
                open24hrs.text = "Open 24 hours: No"
            }else{
                open24hrs.text = "Open 24 hours: Yes"
            }
            open24hrs.textColor = UIColor.whiteColor()
            address.text = "Address: "+restaurant.address
            address.textColor = UIColor.whiteColor()
            var cuisinesString = String()
            for i in (0...(restaurant.cuisine.count-1)){
                cuisinesString = cuisinesString + restaurant.cuisine[i]
                if i != (restaurant.cuisine.count - 1){
                    cuisinesString = cuisinesString + ", "
                }
            }
            cuisine.text = "Cuisines: "+cuisinesString
            cuisine.textColor = UIColor.whiteColor()
            phoneNum.text = "PhoneNum: "+restaurant.phoneNum
            phoneNum.textColor = UIColor.whiteColor()
            website.text = "Website: "+restaurant.website
            
            
            website.textColor = UIColor(red:0.82, green:0.29, blue:0.35, alpha:1.0)
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(DetailRestaurantViewController.tapFunction))
            tapGesture.numberOfTapsRequired = 1
            website.addGestureRecognizer(tapGesture)
            website.userInteractionEnabled = true
            
        } else {
            print("Could not find location of restaurant")
        }
    }
    
    func tapFunction(){
        SweetAlert().showAlert("You will be redirected", subTitle: "Do you want to visit thier website?", style: AlertStyle.warning, buttonTitle:"No", buttonColor:UIColor.colorFromRGB(0xD0D0D0) , otherButtonTitle:  "Yes", otherButtonColor: UIColor.colorFromRGB(0xDD6B55)) { (isOtherButton) -> Void in
            if isOtherButton == true {
                
                
            }
            else {
                
                let targetURL=NSURL(string: (self.restaurant?.website)!)
                
                let application=UIApplication.sharedApplication()
                
                application.openURL(targetURL!);
                
            }
        }

    }
}
