//
//  ResultsViewController.swift
//  WhatIsThis
//
//  Created by NVT on 15.04.18.
//  Copyright © 2018 NVT. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController, ShowDescriptionDelegate {
    
    var descriptionTextView: UITextView!
    
    var imageDescription = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(descriptionTextView)
        update()
    }

    func show(description: String) {
        imageDescription = description
    }
    
    func update() {
        self.descriptionTextView.text = imageDescription
    }
    
}
