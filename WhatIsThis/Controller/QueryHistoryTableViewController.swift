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

    var queryHistory : [String] = []
    var queries = [SearchQuery]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var tableView: UITableView!
    var topBar = TopBar()
    
    let historyTableView = HistoryTableView()
    
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
    
    func loadQueries() {
        let request : NSFetchRequest<SearchQuery> = SearchQuery.fetchRequest()
        
        do{
            queries = try context.fetch(request)
        } catch {
            print("Error loading queriws \(error)")
        }
        
        historyTableView.tableView.reloadData()
    }

    @IBAction func clearQueries() {
        for query in queries {
            context.delete(query)
        }
        viewWillAppear(true)
    }
    
}
