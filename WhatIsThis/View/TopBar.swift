//
//  File.swift
//  WhatIsThis
//
//  Created by NVT on 19.05.18.
//  Copyright © 2018 NVT. All rights reserved.
//

import UIKit

class TopBar: UILabel {
    
    required init() {
        super.init(frame: .zero)
        
        layer.borderColor = UIColor.darkGray.cgColor
        layer.borderWidth = 0.2
        backgroundColor = UIColor(hexString: "F9F9F9")
        font = UIFont.boldSystemFont(ofSize: 18.0)
        numberOfLines = 3
        textAlignment = .center
        text = "\nWhat is this?"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
