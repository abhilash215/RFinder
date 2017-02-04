//
//  CustomizableImageView.swift
//  RFinder
//
//  Created by Saahith Reddy on 12/2/16.
//  Copyright © 2016 AbhilashSU. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class CustomizableImageView: UIImageView {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        
        didSet{
            
            layer.cornerRadius = cornerRadius
        }
        
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        
        didSet {
            
            layer.borderWidth = borderWidth
        }
        
    }
    
}