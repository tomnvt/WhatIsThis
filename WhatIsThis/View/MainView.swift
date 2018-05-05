//
//  MainView.swift
//  WhatIsThis
//
//  Created by NVT on 05.05.18.
//  Copyright © 2018 NVT. All rights reserved.
//

import UIKit

class MainView: UIView {
 
    var saveButton = MainScreenButton(title: "Save")
    var classifyButton = MainScreenButton(title: "Classify")
    var imageView = UIImageView()
    var resultLabel = ResultLabel()
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        self.addSubview(saveButton)
        saveButton.snp.makeConstraints( { (make) -> Void in
            make.right.equalTo(self.snp.right).dividedBy(2).inset(10)
            make.left.equalToSuperview().offset(20)
            make.height.equalTo(self.snp.height).dividedBy(15)
            make.bottom.equalToSuperview().inset(20)
        })
        
        self.addSubview(classifyButton)
        classifyButton.snp.makeConstraints( { (make) -> Void in
            make.right.equalToSuperview().inset(20)
            make.left.equalTo(self.snp.right).dividedBy(2).offset(10)
            make.height.equalTo(self.snp.height).dividedBy(15)
            make.bottom.equalToSuperview().inset(20)
        })
        
        self.addSubview(imageView)
        imageView.snp.makeConstraints( { (make) -> Void in
            make.right.left.equalToSuperview()
            make.height.equalTo(self.snp.height).dividedBy(2)
            make.bottom.equalTo(self.snp.bottom).dividedBy(1.2)
        })
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        
        self.addSubview(resultLabel)
        resultLabel.snp.makeConstraints( { (make) -> Void in
            make.right.left.equalToSuperview()
            make.top.equalToSuperview().offset(self.frame.height / 10)
            make.bottom.equalTo(imageView.snp.top)
        })
        resultLabel.font = resultLabel.font.withSize(self.frame.height / 25)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}