//
//  UIView+Localization.swift
//  WhatIsThis
//
//  Created by NVT on 24.06.18.
//  Copyright © 2018 NVT. All rights reserved.
//

import UIKit

extension UIView {
    func localized(_ this: String) -> String {
        return NSLocalizedString(this, comment: "")
    }
}

