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
    var queries = [SearchQuery]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var imageDescription = ""
    
    let wikipediaView = WikipediaView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(wikipediaView)
        wikipediaView.moreButton.addTarget(self, action: #selector(moreButtonPressed), for: .touchUpInside)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        imageDescription = WikipediaQuery.query
        WikipediaQuery.queryObservable
            .subscribe(onNext: {
                self.hud.dismiss()
                self.wikipediaView.descriptionTextView.text = $0
                self.wikipediaView.moreButton.isEnabled = true
            })
            .disposed(by: bag)
        print(imageDescription)
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
        WikipediaQuery.requestInfo(result: WikipediaQuery.query, longVersion: true)
    }
    
    func saveQuery() {
        let newQuery = SearchQuery(context: self.context)
        newQuery.query = imageDescription
        self.queries.append(newQuery)
        
        do {
            try context.save()
        } catch {
            print("Error saving category \(error)")
        }
    }
}
