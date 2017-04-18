//
//  FavRestaurantCell.swift
//  RFinder
//
//  Created by Saahith Reddy on 12/1/16.
//  Copyright © 2016 AbhilashSU. All rights reserved.
//

import Foundation
import UIKit

class FavRestaurantCell: UITableViewCell {
    
    @IBOutlet weak var fRestaurantName: UILabel!
    @IBOutlet weak var fLocation: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}