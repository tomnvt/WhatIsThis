//
//  ResultsViewController.swift
//  WhatIsThis
//
//  Created by NVT on 15.04.18.
//  Copyright © 2018 NVT. All rights reserved.
//

import UIKit
import SnapKit

class WikipediaQueryViewController: UIViewController, ShowDescriptionDelegate {
    
    var descriptionTextView = UITextView()
    var searchMore = UIBarButtonItem(title: "Search more", style: .plain, target: nil, action: nil)
    
    var imageDescription = ""
     
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Wiki"
        
        view.backgroundColor = .white
        view.addSubview(descriptionTextView)
        descriptionTextView.snp.makeConstraints( { (make) -> Void in
            make.right.left.top.bottom.equalToSuperview().inset(10)
        })
        descriptionTextView.font = .systemFont(ofSize: 16)
        navigationItem.rightBarButtonItem = searchMore
        update()
    }

    func show(description: String) {
        imageDescription = description
    }
    
    func update() {
        self.descriptionTextView.text = imageDescription
    }
    
}
