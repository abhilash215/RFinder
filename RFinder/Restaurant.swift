//
//  Restaurant.swift
//  RFinder
//
//  Created by Rakesh N E on 11/30/16.
//  Copyright © 2016 AbhilashSU. All rights reserved.
//

import Foundation

class Restaurant {
    var name: String
    var rating: String
    var address: String
    var latitude: String
    var longitude: String
    var open24hrs:Int
    var phoneNum:String
    var website:String
    var cuisine:[String]
    var location:String
    
    init(name: String, rating: String, address: String, latitude: String, longitude: String, open24hrs:Int, phoneNum:String,website:String,cuisine:[String],location:String) {
        self.name = name
        self.rating = rating
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
        self.open24hrs = open24hrs
        self.phoneNum = phoneNum
        self.website = website
        self.cuisine = cuisine
        self.location = location
    }
    
}
