//
//  SettingsTableTableViewController.swift
//  WhatIsThis
//
//  Created by NVT on 22.04.18.
//  Copyright © 2018 NVT. All rights reserved.
//

import UIKit

class SettingsTableTableViewController: UITableViewController {

    var settings = ["Soeech synthesizer: ", "CoreML Model", "Save location"]
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settings[0] = defaults.bool(forKey: "speechSynthesisIsOn") ? "Soeech synthesizer: ON" : "Soeech synthesizer: OFF"
    }

    // Add models
    
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
        switch settings[indexPath.row] {
        case ("Soeech synthesizer: ON"), ("Soeech synthesizer: OFF"):
            defaults.set(!defaults.bool(forKey: "speechSynthesisIsOn"), forKey: "speechSynthesisIsOn")
            viewDidLoad()
            break
        case "CoreML Model":
            performSegue(withIdentifier: "goToModels", sender: send)
            break
        default:
            break
        }
        tableView.reloadData()
    }

}
