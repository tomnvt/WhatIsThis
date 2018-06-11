//
//  UIViewController+ShowHideViewGradually.swift
//  WhatIsThis
//
//  Created by NVT on 11.06.18.
//  Copyright © 2018 NVT. All rights reserved.
//

import UIKit

extension UIViewController {
    func setView(view: UIView, hidden: Bool) {
        UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
            view.isHidden = hidden
        })
    }
}
