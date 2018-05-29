//
//  SettingsTableTableViewController.swift
//  WhatIsThis
//
//  Created by NVT on 22.04.18.
//  Copyright © 2018 NVT. All rights reserved.
//

import UIKit
import SnapKit
import JGProgressHUD

class SettingsTableTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private let titles = ["Speech synthesizer", "CoreML Model"]
    private let speechSynthesizerOption = ["ON", "OFF"]
    private var settings = ["Speech synthesizer: ON/OFF", "CoreML Model"]
    private let models = CoreMLModels()
    private let options = [["ON", "OFF"], CoreMLModels().modelNames]
    private let defaults = UserDefaults.standard
    private var myTableView: UITableView!
    private let hud = JGProgressHUD()
    
    let settingsTableView = SettingsTableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(settingsTableView)
        
        settingsTableView.tableView.dataSource = self
        settingsTableView.tableView.delegate = self
        
        settings[0] = defaults.bool(forKey: "speechSynthesisIsOn") ? "Speech synthesizer: ON" : "Speech synthesizer: OFF"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return settings.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options[section].count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return titles[section]
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath)
        cell.textLabel!.text = options[indexPath.section][indexPath.row]
        
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
            switch options[indexPath.section][indexPath.row] {
            case "ON":
                defaults.set(true, forKey: "speechSynthesisIsOn")
                break
            case "OFF":
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
