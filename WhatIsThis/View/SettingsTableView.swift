//
//  SettingsTableView.swift
//  WhatIsThis
//
//  Created by NVT on 23.05.18.
//  Copyright © 2018 NVT. All rights reserved.
//

import UIKit

class SettingsTableView: UIView {

    var tableView: UITableView!
    var topBar = TopBar(text: "\nSettings")
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        
        self.addSubview(topBar)
        topBar.snp.makeConstraints( { (make) -> Void in
            make.right.left.top.equalToSuperview()
            make.bottom.equalTo(self.snp.bottom).dividedBy(11)
        })
        
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        let displayWidth: CGFloat = self.frame.width
        let displayHeight: CGFloat = self.frame.height
        
        tableView = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight - barHeight))
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        
        self.addSubview(tableView)
        tableView.snp.makeConstraints( { (make) -> Void in
            make.left.equalTo(self.snp.left)
            make.right.equalTo(self.snp.right)
            make.top.equalTo(self.snp.bottom).dividedBy(11)
            make.bottom.equalTo(self.snp.bottom)
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
