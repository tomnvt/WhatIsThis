//
//  QueryHistoryTableViewController.swift
//  WhatIsThis
//
//  Created by NVT on 12.05.18.
//  Copyright © 2018 NVT. All rights reserved.
//

import UIKit
import CoreData

class QueryHistoryTableViewController: UITableViewController {

    var queryHistory : [String] = []
    var queries = [SearchQuery]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }

    override func viewWillAppear(_ animated: Bool) {
        loadQueries()
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return queries.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = queries[indexPath.row].query
        return cell
    }
    
    func loadQueries() {
        
        let request : NSFetchRequest<SearchQuery> = SearchQuery.fetchRequest()
        
        do{
            queries = try context.fetch(request)
        } catch {
            print("Error loading categories \(error)")
        }
        
        tableView.reloadData()
        
    }

}
