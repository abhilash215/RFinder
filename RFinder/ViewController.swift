//
//  ViewController.swift
//  RFinder
//
//  Created by abhilash uday on 10/28/16.
//  Copyright © 2016 AbhilashSU. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import CoreLocation
import MapKit
import AVFoundation
import CHPulseButton
import KYWheelTabController


class ViewController: UIViewController, UITableViewDelegate, UITextFieldDelegate,UITabBarControllerDelegate,UITabBarDelegate{//,
    
    @IBOutlet weak var star1: UIImageView!
    var restaurants = [Restaurant]()
    @IBOutlet weak var restaurantTableView: UITableView!
    @IBOutlet weak var searchtextfield: UITextField!
    var cityName: String!
    var window: UIWindow?
    var city1:String!
  
    @IBOutlet weak var roundButton: CHPulseButton!
   
    override func viewDidAppear(animated: Bool) {
        roundButton.animate(start: true)
        if (fbLogin == true){
            let item = (self.tabBarController?.tabBar.items![2])!
            item.enabled = false;
        }
        self.view.makeToast("You can search restaurants.",duration: 2.0, position: .center)
        }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
                let bgColor = UIColor(red:0.15, green:0.14, blue:0.22, alpha:1.0)
        self.restaurantTableView.backgroundColor = bgColor
        if (fbLogin == true){
            let item = (self.tabBarController?.tabBar.items![2])!
            item.enabled = false;
        }
        searchtextfield.delegate  = self
        
        self.restaurantTableView.tableFooterView = UIView()
        
        let vc0 = UIViewController()
        vc0.tabBarItem = UITabBarItem(
            title: "Search",
            image: UIImage(named: "searchicon"),
            selectedImage: UIImage(named: "searchfilled"))
        
        let vc1 = UIViewController()
        vc1.tabBarItem = UITabBarItem(
            title: "User profile",
            image: UIImage(named: "userprofileicon"),
            selectedImage: UIImage(named: "userfilled"))
        
        let vc2 = UIViewController()
        vc2.tabBarItem = UITabBarItem(
            title: "Favorites",
            image: UIImage(named: "favicon"),
            selectedImage: UIImage(named: "heartfilled"))
        
        let vc3 = UIViewController()
        vc3.tabBarItem = UITabBarItem(
            title: "Recipe",
            image: UIImage(named: "recipe"),
            selectedImage: UIImage(named: "recipefilled"))
        let wheelTabController = KYWheelTabController()
        //let wheelTabController = KYWheelTabController()
        wheelTabController.viewControllers = [vc0, vc1, vc2, vc3]
        // wheelTabController.tabBar(<#T##tabBar: UITabBar##UITabBar#>, didSelectItem: UITabBarItem)
        
        /* Customize
         // selected boardre color.
         wheelTabController.tintColor = UIColor.redColor()
         */
    
        self.tabBarController?.delegate = self
        
        window?.rootViewController = wheelTabController
        
    }
    
    
    

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = restaurantTableView.dequeueReusableCellWithIdentifier("RstrntCell", forIndexPath: indexPath) as! RestaurantTableViewCell
        let restaurant = restaurants[indexPath.row]
        cell.nameLabel.text  =  restaurant.name
        cell.nameLabel.textColor = UIColor.whiteColor()
        let num = Double(restaurant.rating)
        
        if( num >= 0 && num <= 1){
            cell.star2.hidden = true
            cell.star3.hidden = true
            cell.star4.hidden = true
            cell.star5.hidden = true
        }else if (num >= 1.1 && num<=2){
            
            cell.star3.hidden = true
            cell.star4.hidden = true
            cell.star5.hidden = true
        }else if(num >= 2.1 && num <= 3){
            cell.star4.hidden = true
            cell.star5.hidden = true
        }else if(num >= 3.1 && num <= 4){
            cell.star5.hidden = true
        }else{
            
        }
        
        cell.addressLabel.text = restaurant.address
        cell.addressLabel.textColor = UIColor.whiteColor()
        
        if(cell.selected){
            cell.backgroundColor = UIColor.clearColor()
        }else{
            cell.backgroundColor = UIColor(red:1.00, green:0.20, blue:0.20, alpha:0.6)
        }

        //cell.backgroundColor = UIColor(red:1.00, green:0.20, blue:0.20, alpha:0.6)
        
        return cell
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        searchtextfield.resignFirstResponder()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        textField.resignFirstResponder()
        return true;
    }
    
    // func for animations
   func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
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
        cell.alpha = 0.7
        
        if(cell.selected){
            cell.backgroundColor = UIColor.clearColor()
        }else{
            cell.backgroundColor = UIColor(red:1.00, green:0.20, blue:0.20, alpha:0.6)
        }
        //cell.backgroundColor = UIColor(red:1.00, green:0.20, blue:0.20, alpha:0.6)
        
    }
    
    // func  search info restaurant
    @IBAction func SearchRest(sender: AnyObject) {
        searchtextfield.resignFirstResponder()
        restaurants.removeAll()
        self.restaurantTableView.reloadData()
        
        // factual api and key
        let apiBegining = "http://api.v3.factual.com/t/restaurants-us?KEY=BXlykcLo11hzxSISFp92ZIfLceXLyEDy0Ir51VA9&filters={\"locality\":{\"$eq\":\""
        let apiEnding = "\"}}"
        
        cityName = searchtextfield.text
        
        if(cityName == ""){
            let alert = UIAlertController(title: "Error", message: "Search Field cant be empty :( ", preferredStyle: UIAlertControllerStyle.Alert)
            let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
            let speechCity = "Please enter the location again"
            let speech = AVSpeechUtterance(string: speechCity)
            let synth = AVSpeechSynthesizer()
            synth.speakUtterance(speech)
        }
            
        else if( cityName.characters.count < 4){
            let speechCity = "Number of characters in location should be more than 4"
            let speech = AVSpeechUtterance(string: speechCity)
            let synth = AVSpeechSynthesizer()
            synth.speakUtterance(speech)
            let alert = UIAlertController(title: "Error", message: "Search text should more than 4 characters :( ", preferredStyle: UIAlertControllerStyle.Alert)
            let action = UIAlertAction(title: "Ok", style: .Default, handler: {action in
                self.searchtextfield.text = ""
            })
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
        if let city = cityName {
            let apiEndPoint = apiBegining + city + apiEnding
            city1 = city
            let encodedString = apiEndPoint.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
                guard let url = NSURL(string: encodedString!) else {
                print("Error: Cannot Create URL")
                return
            }
            
            let urlRequest = NSURLRequest(URL: url)
            // Create NSURL session to send the request
            let config = NSURLSessionConfiguration.defaultSessionConfiguration()
            let session = NSURLSession(configuration: config)
            let task = session.dataTaskWithRequest(urlRequest, completionHandler: parsedata)
            task.resume()
            
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "detailrestaurantview" {
            let detailViewController = segue.destinationViewController as! DetailRestaurantViewController
            
            // Get the cell that generated this segue.
            if let selectedRestaurantCell = sender as? RestaurantTableViewCell {
                let indexPath = restaurantTableView.indexPathForCell(selectedRestaurantCell)!
                let selectedRestaurant = restaurants[indexPath.row]
                detailViewController.restaurant = selectedRestaurant
            }
        } else {
            print("This should not be happening")
        }
    }
    
    
    func parsedata(data:NSData?, response: NSURLResponse?, error: NSError?){
        // Ensure proper data is received.
        guard let reply = data else {
            print("No response data from server")
            return
        }
        
        guard error == nil else {
            print("Error while calling GET method:")
            print(error)
            return
        }
        
        let jsonData: [String:AnyObject]
        do {
            
            jsonData = try NSJSONSerialization.JSONObjectWithData(reply, options: []) as! [String:AnyObject]
        } catch {
            print("error trying to convert data to JSON")
            return
        }
        
        //Parse data from JSON
        let status = jsonData["status"] as! String
        if(status == "error") {
            print("Status: Error")
            print("Error Type: \(jsonData["error_type"])")
            print("Message from server: \(jsonData["message"])")
        } else {
            
            if let response = jsonData["response"] as? [String: AnyObject] {
                let count:Int = response["included_rows"] as! Int
                print (response)
                if count == 0 {
                    let speechCity = "No Restaurants found in the city"
                    let speech = AVSpeechUtterance(string: speechCity)
                    let synth = AVSpeechSynthesizer()
                    synth.speakUtterance(speech)
                    let alertController = UIAlertController(title: "Error", message: "No restaurants found for given city", preferredStyle: .Alert)
                    
                    let okAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
                    alertController.addAction(okAction)
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in self.presentViewController(alertController, animated: true, completion: nil)})
                    return
                }
                let speechCity = "Displaying the restaurants in "+city1
                let speech = AVSpeechUtterance(string: speechCity)
                let synth = AVSpeechSynthesizer()
                synth.speakUtterance(speech)
                
                let hotel_anyobject = response["data"]
                
                let hotel_array = (hotel_anyobject as! NSArray) as Array
                for hotel_data in hotel_array {
                    let hotel = hotel_data as! [String:AnyObject]
                    if(hotel["address"] != nil){
                        if(hotel["website"] != nil){
                            if(hotel["latitude"] != nil){
                                if(hotel["longitude"] != nil){
                                     if(hotel["cuisine"] != nil){
                    let name:String = hotel["name"] as! String
                    let address:String = hotel["address"] as! String
                    let rating:Double = hotel["rating"] as! Double
                    let latitude:Double = hotel["latitude"] as! Double
                    let longitude:Double = hotel["longitude"] as! Double
                    let open24hrs:Int = hotel["open_24hrs"] as! Int
                    let phoneNum:String = hotel["tel"] as! String
                    let website:String = hotel["website"] as! String
                    let cuisine:[String] = hotel["cuisine"] as! [String]
                    let location:String = hotel["locality"] as! String
                    let restaurant = Restaurant(name: name, rating: String(rating), address: address, latitude: String(latitude) , longitude: String(longitude), open24hrs: open24hrs,phoneNum: phoneNum, website: website, cuisine: cuisine,location: location)
                    self.restaurants += [restaurant]
                    
                }
                            }
                        }
                    }
                }
            }
            dispatch_async(dispatch_get_main_queue(), { () -> Void in self.restaurantTableView.reloadData()})
            } else {
                print("Response is not in the expected JSON format")
            }
        }
    }

}

