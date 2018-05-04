//
//  SettingsTableTableViewController.swift
//  WhatIsThis
//
//  Created by NVT on 22.04.18.
//  Copyright © 2018 NVT. All rights reserved.
//

import UIKit
import JGProgressHUD

class SettingsTableTableViewController: UITableViewController {

    var settings = ["Speech synthesizer: ON/OFF", "CoreML Model"]
    let defaults = UserDefaults.standard
    let hud = JGProgressHUD(style: .dark)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        settings[0] = defaults.bool(forKey: "speechSynthesisIsOn") ? "Speech synthesizer: ON" : "Speech synthesizer: OFF"
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
        switch settings[indexPath.row] {
        case ("Speech synthesizer: ON"), ("Speech synthesizer: OFF"):
            defaults.set(!defaults.bool(forKey: "speechSynthesisIsOn"), forKey: "speechSynthesisIsOn")
            viewDidLoad()
            break
        case "CoreML Model":
            hud.show(in: self.view)
            DispatchQueue.main.async {
                let vc = CoreMLModelsTableViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            }
            hud.dismiss()
            break
        default:
            break
        }
        tableView.reloadData()
    }

}
