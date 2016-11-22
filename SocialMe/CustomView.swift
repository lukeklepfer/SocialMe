//
//  CustomView.swift
//  SocialMe
//
//  Created by Luke Klepfer on 11/22/16.
//  Copyright © 2016 Luke. All rights reserved.
//

import UIKit

class CustomView: UIView {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.shadowColor = UIColor(red: CUST_SHADOW_COLOR, green: CUST_SHADOW_COLOR, blue: CUST_SHADOW_COLOR, alpha: 0.6).cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5
        layer.shadowOffset = CGSize(width: 1, height: 1)
    }

}
