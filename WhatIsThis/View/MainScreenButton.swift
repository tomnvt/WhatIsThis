//
//  MainScreenButton.swift
//  WhatIsThis
//
//  Created by NVT on 01.05.18.
//  Copyright © 2018 NVT. All rights reserved.
//

import UIKit

class MainScreenButton: UIButton {
    
    required init(title: String) {
        super.init(frame: CGRect(x: 50, y: 50, width: 50, height: 50))
        
        setTitle(title, for: .normal)
        setTitleColor(.black, for: .normal)
        
        backgroundColor = UIColor(hex: 0xF9F9F9)
        
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1.0
        
        layer.cornerRadius = 0.5 * bounds.size.width
        clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
