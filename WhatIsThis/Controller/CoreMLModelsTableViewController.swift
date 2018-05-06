//
//  CoreMLModelsTableViewController.swift
//  WhatIsThis
//
//  Created by NVT on 25.04.18.
//  Copyright © 2018 NVT. All rights reserved.
//

import UIKit
import JGProgressHUD

class CoreMLModelsTableViewController: UITableViewController {

    let models = CoreMLModels()
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "CoreML Models"
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.modelNames.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = models.modelNames[indexPath.row]
        if indexPath.row == defaults.integer(forKey: "selecteModelNumber") {
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defaults.set(indexPath.row, forKey: "selecteModelNumber")
    }
    
}
