//
//  Recipe.swift
//  RFinder
//
//  Created by Saahith Reddy on 12/3/16.
//  Copyright © 2016 AbhilashSU. All rights reserved.
//

import Foundation
class Recipe  {
    
    var image: NSData
    var ingredients: String
    var steps: String
    var title: String
    
    init(image: NSData, ingredients: String, steps: String, title: String) {
        self.image = image
        self.ingredients = ingredients
        self.steps = steps
        self.title = title
    }
    
    
}