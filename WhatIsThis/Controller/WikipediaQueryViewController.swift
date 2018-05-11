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
import RxSwift
import JGProgressHUD

class WikipediaQueryViewController: UIViewController {
    
    private let bag = DisposeBag()
    
    let hud = JGProgressHUD()
    
    var descriptionTextView = UITextView()
    var searchMoreBarButton = UIBarButtonItem(title: "Search", style: .plain, target: nil, action: #selector(showSearchWikiDialog))
    var moreButton = MainScreenButton(title: "+")
    
    var imageDescription = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Wiki"
        
        view.backgroundColor = .white
        view.addSubview(descriptionTextView)
        descriptionTextView.snp.makeConstraints( { (make) -> Void in
            make.right.left.top.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(51)
        })
        descriptionTextView.font = .systemFont(ofSize: 16)
        descriptionTextView.isEditable = false
        
        view.addSubview(moreButton)
        moreButton.snp.makeConstraints( { (make) -> Void in
            make.right.equalToSuperview().inset(20)
            make.left.equalTo(view.snp.right).dividedBy(1.2)
            make.height.equalTo(view.snp.height).dividedBy(20)
            make.bottom.equalToSuperview().inset(60
            )
        })
        moreButton.isEnabled = false
        moreButton.addTarget(self, action: #selector(moreButtonPressed), for: .touchUpInside)
        
        navigationItem.rightBarButtonItem = searchMoreBarButton
        searchMoreBarButton.target = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        WikipediaQuery.queryObservable
            .subscribe(onNext: {
                self.hud.dismiss()
                self.descriptionTextView.text = $0
                self.moreButton.isEnabled = true
            })
            .disposed(by: bag)
    }
    
    
    @IBAction func showSearchWikiDialog() {
        let searchWikiDialogViewController = SearchWikiDialogViewController()
        
        let popup = PopupDialog(viewController: searchWikiDialogViewController, buttonAlignment: .horizontal, transitionStyle: .zoomIn, gestureDismissal: true)
        
        let buttonOne = CancelButton(title: "Cancel", height: 60, action: nil)
        
        let buttonTwo = DefaultButton(title: "Search", height: 60, dismissOnTap: true) {
            let query = searchWikiDialogViewController.searchTextView.text
            self.updateAfterNewSearch(query: query)
        }
        
        popup.addButtons([buttonOne, buttonTwo])
        
        present(popup, animated: true, completion: nil)
        
    }
    
    func updateAfterNewSearch(query: String?) {
        hud.show(in: self.view)
        guard let enteredText = query else { return }
        imageDescription = enteredText
        print(imageDescription)
        WikipediaQuery.requestInfo(result: imageDescription, longVersion: false)
    }
    
    
    @IBAction func moreButtonPressed() {
        hud.show(in: self.view)
        WikipediaQuery.requestInfo(result: imageDescription, longVersion: true)
    }
    
}
