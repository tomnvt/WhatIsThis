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

    private var settings = ["Speech synthesizer: ON/OFF", "CoreML Model"]
    private let defaults = UserDefaults.standard
    private var myTableView: UITableView!
    private let hud = JGProgressHUD()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height

        myTableView = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight - barHeight))
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        myTableView.dataSource = self
        myTableView.delegate = self
        self.view.addSubview(myTableView)
        
        view.addSubview(myTableView)
        myTableView.snp.makeConstraints( { (make) -> Void in
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            make.top.equalTo(view.snp.bottom).dividedBy(11)
            make.bottom.equalTo(view.snp.bottom)
        })
        
        settings[0] = defaults.bool(forKey: "speechSynthesisIsOn") ? "Speech synthesizer: ON" : "Speech synthesizer: OFF"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath)
        cell.textLabel!.text = "\(settings[indexPath.row])"
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
