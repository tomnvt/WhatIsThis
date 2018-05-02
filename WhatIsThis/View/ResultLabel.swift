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
        super.init(frame: .zero)
        numberOfLines = 2
        textAlignment = .center
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
