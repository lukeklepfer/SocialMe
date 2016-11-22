//
//  CustomTextField.swift
//  SocialMe
//
//  Created by Luke Klepfer on 11/22/16.
//  Copyright © 2016 Luke. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.borderColor = UIColor(red: CUST_SHADOW_COLOR, green: CUST_SHADOW_COLOR, blue: CUST_SHADOW_COLOR, alpha: 0.6).cgColor
        layer.cornerRadius = 5.0
        
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 0)//text inset
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 0)//text inset
    }
}
