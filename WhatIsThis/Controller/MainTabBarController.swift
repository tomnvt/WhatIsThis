//
//  MainTabBarController.swift
//  WhatIsThis
//
//  Created by NVT on 13.05.18.
//  Copyright © 2018 NVT. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
    
    //: MARK: UITabBarController method for view change animation
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        let fromView: UIView = tabBarController.selectedViewController!.view
        let toView  : UIView = viewController.view
        if fromView == toView {
            return false
        }
        
        UIView.transition(from: fromView, to: toView, duration: 0.2, options: UIView.AnimationOptions.transitionCrossDissolve) { (finished:Bool) in
            
        }
        return true
    }

}
