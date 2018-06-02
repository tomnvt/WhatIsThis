//
//  NSMutableAttributedString+Formatting.swift
//  WhatIsThis
//
//  Created by NVT on 02.06.18.
//  Copyright © 2018 NVT. All rights reserved.
//

import Foundation

extension NSMutableAttributedString {
    @discardableResult func bold(_ text: String) -> NSMutableAttributedString {
        let attrs: [NSAttributedStringKey: Any] = [.font: (name: "AvenirNext-Medium", size: 12)]
        let boldString = NSMutableAttributedString(string:text, attributes: attrs)
        append(boldString)
        
        return self
    }
    
    @discardableResult func normal(_ text: String) -> NSMutableAttributedString {
        let normal = NSAttributedString(string: text)
        append(normal)
        
        return self
    }
}
