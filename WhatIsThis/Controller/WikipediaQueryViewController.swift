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
    var queries = [SearchQuery]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let wikipediaView = WikipediaView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(wikipediaView)
        wikipediaView.moreButton.addTarget(self, action: #selector(moreButtonPressed), for: .touchUpInside)
        wikipediaView.newQueryButton.addTarget(self, action: #selector(showSearchWikiDialog), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        WikipediaQuery.queryObservable
            .subscribe(onNext: {
                self.hud.dismiss()
                self.wikipediaView.descriptionTextView.text = $0 + "\n\n\n\n\n"
                self.setView(view: self.wikipediaView.descriptionTextView, hidden: false)
                self.wikipediaView.moreButton.isEnabled = true
            })
            .disposed(by: bag)
        WikipediaQuery.queryLengthObservable
            .subscribe(onNext: {
                if $0 == false {
                    self.setView(view: self.wikipediaView.moreButton, hidden: false)
                }
            })
            .disposed(by: bag)
    }
    
    
    @IBAction func showSearchWikiDialog() {
        let searchWikiDialogViewController = SearchWikiDialogViewController()
        
        let popup = PopupDialog(viewController: searchWikiDialogViewController, buttonAlignment: .horizontal, transitionStyle: .zoomIn, gestureDismissal: true)
        
        let cancelButton = CancelButton(title: "Cancel", height: 60, action: nil)
        
        let searchButton = DefaultButton(title: "Search", height: 60, dismissOnTap: true) {
            self.setView(view: self.wikipediaView.startInfoLabel, hidden: true)
            let query = searchWikiDialogViewController.searchTextView.text
            self.updateAfterNewSearch(query: query)
        }
        
        popup.addButtons([cancelButton, searchButton])
        
        present(popup, animated: true, completion: nil)
        
    }
    
    func updateAfterNewSearch(query: String?) {
        hud.show(in: self.view)
        guard let enteredText = query else { return }
        WikipediaQuery.query = enteredText
        WikipediaQuery.requestInfo(result: enteredText, longVersion: false)
    }
    
    @IBAction func moreButtonPressed() {
        hud.show(in: self.view)
        WikipediaQuery.requestInfo(result: WikipediaQuery.query, longVersion: true)
        self.setView(view: self.wikipediaView.moreButton, hidden: true)
    }
    
    func setView(view: UIView, hidden: Bool) {
        UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
            view.isHidden = hidden
        })
    }
    
}
