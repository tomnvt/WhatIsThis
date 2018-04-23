//
//  SettingsTableTableViewController.swift
//  WhatIsThis
//
//  Created by NVT on 22.04.18.
//  Copyright © 2018 NVT. All rights reserved.
//

import UIKit

class SettingsTableTableViewController: UITableViewController {

    let settings = ["Soeech synthesizer", "Save location", "CoreML Model"]
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = settings[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = settings[indexPath.row]
        switch selectedItem {
        case "Soeech synthesizer":
            defaults.set(!defaults.bool(forKey: "speechSynthesisIsOn"), forKey: "speechSynthesisIsOn")
            print(defaults.bool(forKey: "speechSynthesisIsOn"))
            break
        default:
            break
        }
        tableView.reloadData()
    }

}
