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

    private var queries: SearchQueries?
    private var queriesByDate = [String : [String]]()
    private var queryByDateSorted = [(key: String, value: [String])]()
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
        queries = SearchQueries()
        queriesByDate = unwrapOptional(dictionary: queries?.queriesByDate)
        queryByDateSorted = queriesByDate.sorted(by: { $0.0 < $1.0 })
        
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
        return queryByDateSorted.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return queryByDateSorted.reversed()[section].key
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return queryByDateSorted.reversed()[section].value.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = (queryByDateSorted.reversed()[indexPath.section].value).reversed()[indexPath.row]
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
        clearConfirmation.title = NSLocalizedString("Are you sure you want to clear the history?", comment: "")
        
        let yesButton = UIAlertAction(title: NSLocalizedString("Yes, clear it!", comment: ""), style: .destructive) { _ in
            self.queries?.clearQueries()
            self.setView(view: self.historyTableView.tableView, hidden: true)
            self.setView(view: self.historyTableView.startInfoLabel, hidden: false)
        }
        
        clearConfirmation.addAction(yesButton)
        clearConfirmation.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil))
        
        present(clearConfirmation, animated: true, completion: nil)
    }
    
    // MARK: - Row tap action
    // After tapping a row, UIAlert asks if the user wants to search the tapped history item again
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let wordToSearchAgain = tableView.cellForRow(at: indexPath)?.textLabel?.text else { return }
        searchAgain(wordToSearchAgain: wordToSearchAgain)
    }
    
    func unwrapOptional(dictionary: [String: [String]]?) -> [String: [String]] {
        var unwrapedDictionary = [String: [String]]()
        if let dictionaryBeingUnwraped = dictionary {
            unwrapedDictionary = dictionaryBeingUnwraped
        }
        return unwrapedDictionary
    }
    
    func searchAgain(wordToSearchAgain: String) {
        let searchAgainAlert = UIAlertController(title: NSLocalizedString("Search \n\"", comment: "")
            + wordToSearchAgain
            + NSLocalizedString("\"\n again?", comment: ""), message: nil, preferredStyle: . alert)
        let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
            WikipediaQuery.querySubject.onNext("")
            WikipediaQuery.query = wordToSearchAgain
            WikipediaQuery.requestInfo(queryString: wordToSearchAgain, longVersion: false, repeatedSearch: true)
            
            let fromView: UIView = self.tabBarController!.selectedViewController!.view
            let toView  : UIView = self.tabBarController!.viewControllers![1].view
            
            UIView.transition(from: fromView, to: toView, duration: 0.2, options: UIViewAnimationOptions.transitionCrossDissolve) { (finished:Bool) in
                self.tabBarController?.selectedIndex = 1
            }
        }
        
        let noAction = UIAlertAction(title: NSLocalizedString("No", comment: ""), style: .default) { _ in }
        
        searchAgainAlert.addAction(noAction)
        searchAgainAlert.addAction(yesAction)
        
        present(searchAgainAlert, animated: true, completion: nil)
    }
    
}
