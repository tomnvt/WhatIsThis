//
//  CircularButton.swift
//  WhatIsThis
//
//  Created by NVT on 31.05.18.
//  Copyright © 2018 NVT. All rights reserved.
//

import UIKit

class CustomButton: UIButton {
    
    required init(title: String) {
        super.init(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        
        setTitle(title, for: .normal)
        setTitleColor(.black, for: .normal)
        
        backgroundColor = UIColor(hexString: "F9F9F9")
        
        clipsToBounds = true
        layer.masksToBounds = false
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 1.0
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 2
        
        layer.cornerRadius = frame.width / 3
        
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    

}
