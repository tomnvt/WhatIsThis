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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height

        tableView = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight - barHeight))
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        tableView.dataSource = self
        tableView.delegate = self
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints( { (make) -> Void in
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            make.top.equalTo(view.snp.bottom).dividedBy(11)
            make.bottom.equalTo(view.snp.bottom)
        })
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }

    override func viewWillAppear(_ animated: Bool) {
        loadQueries()
        tableView.reloadData()
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
            print("Error loading categories \(error)")
        }
        
        tableView.reloadData()
        
    }

}
