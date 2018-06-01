//
//  ResultLabel.swift
//  WhatIsThis
//
//  Created by NVT on 01.05.18.
//  Copyright © 2018 NVT. All rights reserved.
//

import UIKit

class ResultLabel: UILabel {
    
    required init() {
        super.init(frame: CGRect(x: 50, y: 50, width: 50, height: 50))
        numberOfLines = 2
        textAlignment = .center
                
        backgroundColor = UIColor(hexString: "D9DADA")
        
        clipsToBounds = true
        layer.masksToBounds = true
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 1.0
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 2
        
        layer.cornerRadius = frame.width / 2
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
