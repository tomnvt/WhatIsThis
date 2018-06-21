//
//  SettingsTableTableViewController.swift
//  WhatIsThis
//
//  Created by NVT on 22.04.18.
//  Copyright © 2018 NVT. All rights reserved.
//

import UIKit
import SnapKit

class SettingsTableTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private let settings = [NSLocalizedString("Speech Synthesis", comment: ""):
                        [NSLocalizedString("ON", comment: ""), NSLocalizedString("OFF", comment: "")],
                            NSLocalizedString("Classification Model", comment: ""): CoreMLModels().modelNames]
    private let defaults = UserDefaults.standard
    private let settingsTableView = SettingsTableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(settingsTableView)
        
        settingsTableView.tableView.dataSource = self
        settingsTableView.tableView.delegate = self
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return settings.keys.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Array(settings.values)[section].count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Array(settings.keys)[section]
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath)
        cell.textLabel!.text = Array(settings.values)[indexPath.section][indexPath.row]
        
        switch indexPath.section {
            
        case 0:
            switch indexPath.row {
            case 0:
                cell.accessoryType = defaults.bool(forKey: "speechSynthesisIsOn") ? .checkmark : .none
                break
            case 1:
                cell.accessoryType = !defaults.bool(forKey: "speechSynthesisIsOn") ? .checkmark : .none
                break
            default:
                break
            }
            
        case 1:
            switch indexPath.row {
            case defaults.integer(forKey: "selecteModelNumber"):
                cell.accessoryType = .checkmark
            default:
                cell.accessoryType = .none
                break
            }
            break
            
        default:
            break
        }
        
        return cell
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                defaults.set(true, forKey: "speechSynthesisIsOn")
                break
            case 1:
                defaults.set(false, forKey: "speechSynthesisIsOn")
                break
            default:
                break
            }
            break
        case 1:
            defaults.set(indexPath.row, forKey: "selecteModelNumber")
            break
        default:
            break
        }
        
        tableView.reloadData()
    }

}
