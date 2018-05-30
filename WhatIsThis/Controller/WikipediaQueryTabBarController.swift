//
//  WikipediaQueryTabBarController.swift
//  WhatIsThis
//
//  Created by NVT on 11.05.18.
//  Copyright © 2018 NVT. All rights reserved.
//

import UIKit
import RxSwift
import PopupDialog
import JGProgressHUD
import CoreData

class WikipediaQueryTabBarController: UITabBarController, UITabBarControllerDelegate {

    let item1 = WikipediaQueryViewController()
    let item2 = QueryHistoryTableViewController()
    var queries = [SearchQuery]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var searchMoreBarButton = UIBarButtonItem(title: "Search", style: .plain, target: nil, action: #selector(showSearchWikiDialog))
    let bag = DisposeBag()
    let hud = JGProgressHUD()
    var imageDescription = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        
        navigationItem.rightBarButtonItem = searchMoreBarButton
        searchMoreBarButton.target = self
        
        WikipediaQuery.queryObservable
            .subscribe({_ in 
                self.hud.dismiss()
                self.saveQuery()
            })
            .disposed(by: bag)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let icon1 = UITabBarItem(title: "Title", image: UIImage(named: "someImage.png"), selectedImage: UIImage(named: "otherImage.png"))
        item1.tabBarItem = icon1
        let controllers = [item1, item2]  //array of the root view controllers displayed by the tab bar interface
        self.viewControllers = controllers
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        return true;
    }
    
    override func viewDidAppear(_ animated: Bool) {
        guard imageDescription != "" else { return }
        item1.updateAfterNewSearch(query: imageDescription)
        item2.queryHistory.append(imageDescription)
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
        item2.queryHistory.append(enteredText.uppercased())
        item1.imageDescription = enteredText
        imageDescription = enteredText
        WikipediaQuery.requestInfo(result: enteredText, longVersion: false)
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
