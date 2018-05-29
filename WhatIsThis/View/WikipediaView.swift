//
//  WikipediaView.swift
//  WhatIsThis
//
//  Created by NVT on 20.05.18.
//  Copyright © 2018 NVT. All rights reserved.
//

import UIKit

class WikipediaView: UIView {
    
    var topBar = TopBar(text: "\nWikipedia")
    var descriptionTextView = UITextView()
    var moreButton = MainScreenButton(title: "+")
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)

        backgroundColor = .white
        
        addSubview(topBar)
        topBar.snp.makeConstraints( { (make) -> Void in
            make.right.left.top.equalToSuperview()
            make.bottom.equalTo(self.snp.bottom).dividedBy(11)
        })
        
        addSubview(descriptionTextView)
        descriptionTextView.snp.makeConstraints( { (make) -> Void in
            make.right.left.equalToSuperview().inset(10)
            make.top.equalToSuperview().inset(70)
            make.bottom.equalToSuperview().inset(52)
        })
        descriptionTextView.font = .systemFont(ofSize: 16)
        descriptionTextView.isEditable = false
        
        addSubview(moreButton)
        moreButton.snp.makeConstraints( { (make) -> Void in
            make.right.equalToSuperview().inset(20)
            make.left.equalTo(self.snp.right).dividedBy(1.2)
            make.height.equalTo(self.snp.height).dividedBy(20)
            make.bottom.equalToSuperview().inset(60)
        })
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
