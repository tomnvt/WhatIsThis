//
//  CGImagePropertyOrientation.swift
//  WhatIsThis
//
//  Created by NVT on 27.04.18.
//  Copyright © 2018 NVT. All rights reserved.
//

import UIKit

extension CGImagePropertyOrientation {
    init(_ orientation: UIImageOrientation) {
        switch orientation {
        case .up: self = .up
        case .upMirrored: self = .upMirrored
        case .down: self = .down
        case .downMirrored: self = .downMirrored
        case .left: self = .left
        case .leftMirrored: self = .leftMirrored
        case .right: self = .right
        case .rightMirrored: self = .rightMirrored
        }
    }
}
