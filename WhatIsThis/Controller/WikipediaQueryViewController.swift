//
//  ResultsViewController.swift
//  WhatIsThis
//
//  Created by NVT on 15.04.18.
//  Copyright © 2018 NVT. All rights reserved.
//

import UIKit
import SnapKit
import PopupDialog

class WikipediaQueryViewController: UIViewController, ShowDescriptionDelegate {
    
    var descriptionTextView = UITextView()
    var searchMore = UIBarButtonItem(title: "Search", style: .plain, target: nil, action: #selector(showSearchWikiDialog))
    
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
        descriptionTextView.isUserInteractionEnabled = false
        
        navigationItem.rightBarButtonItem = searchMore
        searchMore.target = self
        
        update()
    }

    func show(description: String) {
        imageDescription = description
    }
    
    func update() {
        self.descriptionTextView.text = imageDescription
    }
    
    @IBAction func showSearchWikiDialog() {
        let searchWikiDialogViewController = SearchWikiDialogViewController()
        
        let popup = PopupDialog(viewController: searchWikiDialogViewController, buttonAlignment: .horizontal, transitionStyle: .zoomIn, gestureDismissal: true)
        
        let buttonOne = CancelButton(title: "Cancel", height: 60, action: nil)
        
        let buttonTwo = DefaultButton(title: "Search", height: 60, dismissOnTap: true) {
            if let enteredText = searchWikiDialogViewController.searchTextView.text {
                print(enteredText)
            }
        }
        
        popup.addButtons([buttonOne, buttonTwo])
        
        present(popup, animated: true, completion: nil)
        
    }
    
}
