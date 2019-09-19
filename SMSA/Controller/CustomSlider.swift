//
//  CustomSlider.swift
//  SMSA
//
//  Created by Matthew Androus on 9/18/19.
//  Copyright © 2019 SMSA Devs. All rights reserved.
//

import UIKit

class CustomSlider: UISlider {
    @IBInspectable var trackHeight: CGFloat = 5
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(origin: bounds.origin, size: CGSize(width: bounds.width, height: trackHeight))
    }
    
    
}
