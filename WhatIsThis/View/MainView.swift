//
//  MainView.swift
//  WhatIsThis
//
//  Created by NVT on 05.05.18.
//  Copyright © 2018 NVT. All rights reserved.
//

import UIKit
import SwiftRichString

class MainView: UIView {
    
    var saveButton = CustomButton(title: "Save")
    var classifyButton = CustomButton(title: "")
    var imageView = UIImageView()
    var resultLabel = ResultLabel()
    var startInfoLabel = UILabel()
    var topBar = TopBar(text: NSLocalizedString("\nWhat is this?", comment: ""))
    
    let normal = Style {
        $0.font = SystemFonts.Helvetica_Light.font(size: 30)
    }
    
    let bold = Style {
        $0.font = SystemFonts.Helvetica_Bold.font(size: 30)
    }
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        self.addSubview(imageView)
        imageView.snp.makeConstraints( { (make) -> Void in
            make.right.left.top.bottom.equalToSuperview()
        })
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        
        addSubview(startInfoLabel)
        startInfoLabel.snp.makeConstraints( { (make) -> Void in
            make.right.left.top.bottom.equalToSuperview()
        })
        
        let styleGroup = StyleGroup(base: normal, ["bold": bold])
        
        startInfoLabel.textAlignment = .center
        startInfoLabel.numberOfLines = 3
        let startInfoText = localized("<bold>TAKE A PHOTO</bold>\nOR\n<bold>CHOOSE ONE</bold>")
        startInfoLabel.attributedText = startInfoText.set(style: styleGroup)
        
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
            make.bottom.equalTo(self.snp.bottom).dividedBy(10)
        })
        
        self.addSubview(saveButton)
        saveButton.snp.makeConstraints( { (make) -> Void in
            make.right.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(70)
            make.height.equalTo(self.snp.height).dividedBy(10)
            make.width.equalTo(saveButton.snp.height)
        })
        saveButton.isHidden = true

        self.addSubview(classifyButton)
        classifyButton.snp.makeConstraints( { (make) -> Void in
            make.left.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().inset(70)
            make.height.equalTo(self.snp.height).dividedBy(10)
            make.width.equalTo(classifyButton.snp.height)
        })
        classifyButton.setImage(TabBarImages.cameraImage, for: .normal)
            
        self.backgroundColor = UIColor(hexString: "D9DADA")
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
