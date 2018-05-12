//
//  QueryHistoryTableViewController.swift
//  WhatIsThis
//
//  Created by NVT on 12.05.18.
//  Copyright © 2018 NVT. All rights reserved.
//

import UIKit

class QueryHistoryTableViewController: UITableViewController {

    var queryHistory : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "History"
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }

    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return queryHistory.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = queryHistory[indexPath.row]
        return cell
    }

}
