//
//  CustomButton.swift
//  SocialMe
//
//  Created by Luke Klepfer on 11/22/16.
//  Copyright © 2016 Luke. All rights reserved.
//

import UIKit

class CustomButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.shadowColor = UIColor(colorLiteralRed: Float(CUST_SHADOW_COLOR), green: Float(CUST_SHADOW_COLOR), blue: Float(CUST_SHADOW_COLOR), alpha: 0.6).cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5
        layer.shadowOffset = CGSize(width: 1, height: 1)
        imageView?.contentMode = .scaleAspectFit
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if ((imageView?.image) != nil) {
            //button with image
            layer.cornerRadius = self.frame.width/2
        }else{
            //reg button
            layer.cornerRadius = 5
        }
    }

}
