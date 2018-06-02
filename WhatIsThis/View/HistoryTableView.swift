//
//  HistoryTableView.swift
//  WhatIsThis
//
//  Created by NVT on 22.05.18.
//  Copyright © 2018 NVT. All rights reserved.
//

import UIKit

class HistoryTableView: UIView {
    
    var tableView: UITableView!
    var topBar = TopBar(text: "\nHistory")
    let clearButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)

        self.addSubview(topBar)
        topBar.snp.makeConstraints( { (make) -> Void in
            make.right.left.top.equalToSuperview()
            make.bottom.equalTo(self.snp.bottom).dividedBy(10)
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
            make.top.equalTo(self.topBar.snp.bottom)
            make.bottom.equalTo(self.snp.bottom)
        })
        
        self.addSubview(clearButton)
        clearButton.setTitle("Clear", for: .normal)
        clearButton.setTitleColor(.blue, for: .normal)
        clearButton.snp.makeConstraints( { (make) -> Void in
            make.right.equalToSuperview().inset(10)
            make.left.equalTo(snp.right).inset(60)
            make.top.equalTo(snp.top).offset(24)
            make.bottom.equalTo(topBar.snp.bottom)
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
