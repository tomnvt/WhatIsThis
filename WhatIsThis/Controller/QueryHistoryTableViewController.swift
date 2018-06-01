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

    private var queries = [SearchQuery]()
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private let historyTableView = HistoryTableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(historyTableView)

        historyTableView.tableView.dataSource = self
        historyTableView.tableView.delegate = self

        historyTableView.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        historyTableView.clearButton.addTarget(self, action: #selector(clearQueries), for: .touchUpInside)
    }

    
    override func viewWillAppear(_ animated: Bool) {
        loadQueries()
        historyTableView.tableView.reloadData()
    }

    
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return queries.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = queries[indexPath.row].query
        return cell
    }
    
    
    //: MARK: - Method for loading saved queries from context
    
    func loadQueries() {
        let request : NSFetchRequest<SearchQuery> = SearchQuery.fetchRequest()
        
        do{
            queries = try context.fetch(request)
        } catch {
            print("Error loading queriws \(error)")
        }
        
        historyTableView.tableView.reloadData()
    }

    
    //: MARK: - Method for removing all saved queries from the context
    
    @IBAction func clearQueries() {
        guard queries != [] else {
            let nothingToClearAlert = UIAlertController(title: "Nothing to clear here.", message: nil, preferredStyle: .alert)
            nothingToClearAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(nothingToClearAlert, animated: true)
            return
        }
        
        let clearConfirmation = UIAlertController()
        clearConfirmation.title = "Are you sure you want to clear the history?"
        
        let yesButton = UIAlertAction(title: "Yes, clear it!", style: .destructive) { _ in
            for query in self.queries {
                self.context.delete(query)
            }
            self.viewWillAppear(true)
        }
        
        clearConfirmation.addAction(yesButton)
        clearConfirmation.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(clearConfirmation, animated: true)
    }

}
