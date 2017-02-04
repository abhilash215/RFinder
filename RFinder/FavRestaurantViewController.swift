//
//  FavRestaurantViewController.swift
//  RFinder
//
//  Created by Saahith Reddy on 12/1/16.
//  Copyright © 2016 AbhilashSU. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase
import KYWheelTabController
class FavRestaurantViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    @IBOutlet weak var favRestTableView: UITableView!
    
    @IBOutlet weak var Favorites: UILabel!
    var window: UIWindow?
    var rsts = [String]()
    var refreshControl:UIRefreshControl!
    
    override func viewDidAppear(animated: Bool) {
        self.view.makeToast("Your Favorites",duration: 2.0, position: .center)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // Favorites.text = "Favorites"
        self.title = "Favorites"
        //self.view.makeToast("Your Favorites",duration: 2.0, position: .center)
        rsts = favRestArray
        self.favRestTableView.tableFooterView = UIView()
        let bgColor = UIColor(red:0.15, green:0.14, blue:0.22, alpha:1.0)
        self.favRestTableView.backgroundColor = bgColor
        favRestTableView.delegate = self
        favRestTableView.dataSource = self
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(FavRestaurantViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        favRestTableView.addSubview(refreshControl) // not required when using UITableViewController
      
    }
    
    func refresh(sender:AnyObject) {
        // Code to refresh table view
        rsts = favRestArray
        self.favRestTableView.reloadData()
        refreshControl?.endRefreshing()
        
    }
    
    func sortArray() {
        self.favRestTableView.reloadData()
        refreshControl?.endRefreshing()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return rsts.count
        }else {
            return 1
        }
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if(indexPath.section != 1){
            
            return true
        }else{
            return false
        }
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let item = rsts[indexPath.row]
            let title = "Delete \(item.componentsSeparatedByString("+")[0])?"
            let message = "Are you sure?"
            
            SweetAlert().showAlert(title, subTitle: message, style: AlertStyle.warning, buttonTitle:"No", buttonColor:UIColor.colorFromRGB(0xD0D0D0) , otherButtonTitle:  "Yes", otherButtonColor: UIColor.colorFromRGB(0xDD6B55)) { (isOtherButton) -> Void in
                if isOtherButton == true {
                    
                    SweetAlert().showAlert("Cancelled!", subTitle: "Restaurant is not deleted", style: AlertStyle.error)
                }
                else {
                    self.rsts.removeAtIndex(indexPath.row)
                    favRestArray = self.rsts
                    let parentRef = FIRDatabase.database().reference().child("users").child((FIRAuth.auth()?.currentUser?.uid)!).child("FavRes")
                    parentRef.setValue(favRestArray)
                    self.favRestTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                    
                    SweetAlert().showAlert("Success!", subTitle: "Restaurant is deleted from the list", style: AlertStyle.success)
                    
                }
            }
            
        }
    }
    
    
    
    func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String? {
        return "Remove"
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 1{
            let noMoreItemsCell = tableView.dequeueReusableCellWithIdentifier("NoMoreItemsCell",forIndexPath: indexPath) as! NoMoreItemsCell
            
            return noMoreItemsCell
        }else{
        
        let cell = favRestTableView.dequeueReusableCellWithIdentifier("FavRestaurantCell", forIndexPath: indexPath) as! FavRestaurantCell
        let restaurant = rsts[indexPath.row]
        cell.fRestaurantName.text = restaurant.componentsSeparatedByString("+")[0]
            cell.fRestaurantName.textColor = UIColor.whiteColor()
            cell.fLocation.textColor = UIColor.whiteColor()
        cell.fLocation.text = restaurant.componentsSeparatedByString("+")[1]
            cell.layer.borderWidth = 0.75
            cell.layer.borderColor = UIColor.whiteColor().CGColor
            cell.backgroundColor = UIColor(red:1.00, green:0.20, blue:0.20, alpha:0.6)
            cell.alpha = 0.7
            
        return cell
        }
    }
    
    
    
    // func for animations
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if(indexPath.section != 1){
        CellAnimator.animateCell(cell, withTransform: CellAnimator.TransformHelix, andDuration: 1)
        cell.layer.transform = CATransform3DMakeScale(0.1,0.1,1)
        UIView.animateWithDuration(0.3, animations: {
            cell.layer.transform = CATransform3DMakeScale(1.05,1.05,1)
            },completion: { finished in
                UIView.animateWithDuration(0.8, animations: {
                    cell.layer.transform = CATransform3DMakeScale(1,1,1)
                })
        })
        
        cell.layer.borderWidth = 0.75
        cell.layer.borderColor = UIColor.whiteColor().CGColor
        cell.backgroundColor = UIColor(red:0.82, green:0.29, blue:0.35, alpha:1.0)
        cell.alpha = 0.7
        
        
        
        }
        
    }

    
}