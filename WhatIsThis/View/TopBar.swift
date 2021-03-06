//
//  File.swift
//  WhatIsThis
//
//  Created by NVT on 19.05.18.
//  Copyright © 2018 NVT. All rights reserved.
//

import UIKit

class TopBar: UILabel {
    
    required init(text: String) {
        super.init(frame: .zero)
        
        layer.borderColor = UIColor.gray.cgColor
        layer.borderWidth = 0.5
        backgroundColor = UIColor(hexString: "F9F9F9")
        font = UIFont.boldSystemFont(ofSize: 18.0)
        numberOfLines = 3
        textAlignment = .center
        self.text = text
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
