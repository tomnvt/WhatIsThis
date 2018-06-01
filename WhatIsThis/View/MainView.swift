//
//  MainView.swift
//  WhatIsThis
//
//  Created by NVT on 05.05.18.
//  Copyright © 2018 NVT. All rights reserved.
//

import UIKit

class MainView: UIView {
    
    var saveButton = CustomButton(title: "Save")
    var classifyButton = CustomButton(title: "Classify")
    var imageView = UIImageView()
    var resultLabel = ResultLabel()
    var startInfo = UILabel()
    var topBar = TopBar(text: "\nWhat is this?")

    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        self.addSubview(imageView)
        imageView.snp.makeConstraints( { (make) -> Void in
            make.right.left.top.bottom.equalToSuperview()
        })
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        
        addSubview(startInfo)
        startInfo.snp.makeConstraints( { (make) -> Void in
            make.right.left.top.bottom.equalToSuperview()
        })
        startInfo.textAlignment = .center
        startInfo.numberOfLines = 3
        startInfo.text = "TAKE A PHOTO\nOR\nCHOOSE ONE FROM YOUR LIBRARY"
        
        self.addSubview(resultLabel)
        resultLabel.snp.makeConstraints( { (make) -> Void in
            make.right.left.equalToSuperview().inset(50)
            make.top.equalToSuperview().offset(self.frame.height / 8.5)
            make.bottom.equalTo(self.snp.bottom).multipliedBy(0.30)
        })
        resultLabel.font = resultLabel.font.withSize(self.frame.height / 25)
        
        addSubview(topBar)
        topBar.snp.makeConstraints( { (make) -> Void in
            make.right.left.top.equalToSuperview()
            make.bottom.equalTo(self.snp.bottom).dividedBy(11)
        })
        
        self.addSubview(saveButton)
        saveButton.snp.makeConstraints( { (make) -> Void in
            make.right.equalTo(self.snp.right).dividedBy(2).inset(10)
            make.left.equalToSuperview().offset(20)
            make.height.equalTo(self.snp.height).dividedBy(15)
            make.bottom.equalToSuperview().inset(70)
        })
        saveButton.isHidden = true
        
        self.addSubview(classifyButton)
        classifyButton.snp.makeConstraints( { (make) -> Void in
            make.right.equalToSuperview().inset(20)
            make.left.equalTo(self.snp.right).dividedBy(2).offset(10)
            make.height.equalTo(self.snp.height).dividedBy(15)
            make.bottom.equalToSuperview().inset(70)
        })
        
        self.backgroundColor = UIColor(hexString: "D9DADA")
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
