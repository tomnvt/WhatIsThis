//
//  QueryHistoryTableViewController.swift
//  WhatIsThis
//
//  Created by NVT on 12.05.18.
//  Copyright © 2018 NVT. All rights reserved.
//

import UIKit
import CoreData

class QueryHistoryTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var queries : SearchQueries?
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private let historyTableView = HistoryTableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(historyTableView)

        historyTableView.tableView.dataSource = self
        historyTableView.tableView.delegate = self

        historyTableView.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        historyTableView.clearButton.addTarget(self, action: #selector(clearButtonPressed), for: .touchUpInside)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print(historyTableView.startInfoLabel.isHidden)
        queries = SearchQueries()
        historyTableView.tableView.reloadData()
        if queries?.queries.count == 0 {
            historyTableView.tableView.isHidden = true
            historyTableView.startInfoLabel.isHidden = false
        } else {
            historyTableView.tableView.isHidden = false
            historyTableView.startInfoLabel.isHidden = true
        }
    }

    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return queries?.queries.count ?? 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = queries?.queries[indexPath.row].query
        return cell
    }
    
    
    // MARK: - Clear button action
    // After "Clear" button is pressed, UIAlert requests confirmation, then clears the history or stops
    @IBAction func clearButtonPressed() {
        guard queries?.queries.count != 0 else {
            let nothingToClearAlert = UIAlertController(title: "Nothing to clear here.", message: nil, preferredStyle: .alert)
            nothingToClearAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(nothingToClearAlert, animated: true)
            return
        }
        
        let clearConfirmation = UIAlertController()
        clearConfirmation.title = "Are you sure you want to clear the history?"
        
        let yesButton = UIAlertAction(title: "Yes, clear it!", style: .destructive) { _ in
            print("Yes button pressed")
            self.queries?.clearQueries()
            self.historyTableView.startInfoLabel.isHidden = false
            self.historyTableView.tableView.isHidden = true
        }
        
        clearConfirmation.addAction(yesButton)
        clearConfirmation.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(clearConfirmation, animated: true, completion: nil)
    }
    
    
    // MARK: - Row tap action
    // After tapping a row, UIAlert asks if the user wants to search the tapped history item again
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let wordToSearchAgain = queries?.queries[indexPath.row].query else { return }
        
        let searchAgainAlert = UIAlertController(title: "Search \n\"\(wordToSearchAgain)\"\n again?", message: nil, preferredStyle: . alert)
        let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
            WikipediaQuery.querySubject.onNext("")
            WikipediaQuery.query = wordToSearchAgain
            WikipediaQuery.requestInfo(result: wordToSearchAgain, longVersion: false, repeatedSearch: true)
            
            let fromView: UIView = self.tabBarController!.selectedViewController!.view
            let toView  : UIView = self.tabBarController!.viewControllers![1].view

            UIView.transition(from: fromView, to: toView, duration: 0.2, options: UIViewAnimationOptions.transitionCrossDissolve) { (finished:Bool) in
                self.tabBarController?.selectedIndex = 1
            }
        }
        
        let noAction = UIAlertAction(title: "No", style: .default) { _ in
            print("Not gonna search")
        }
        
        searchAgainAlert.addAction(noAction)
        searchAgainAlert.addAction(yesAction)
        
        present(searchAgainAlert, animated: true, completion: nil)
    }

}
