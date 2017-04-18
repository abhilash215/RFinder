//
//  RecipeCell.swift
//  RFinder
//
//  Created by Saahith Reddy on 12/3/16.
//  Copyright © 2016 AbhilashSU. All rights reserved.
//

import Foundation
import UIKit
class RecipeCell: UITableViewCell {
    
    @IBOutlet weak var recipeTitle: UILabel!
    @IBOutlet weak var recipeImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
}