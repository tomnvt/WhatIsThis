//
//  WikipediaView.swift
//  WhatIsThis
//
//  Created by NVT on 20.05.18.
//  Copyright © 2018 NVT. All rights reserved.
//

import UIKit
import SwiftRichString
import Stevia

class WikipediaView: UIView {
    
    var topBar = TopBar(text: NSLocalizedString("\nWikipedia", comment: ""))
    var descriptionTextView = UITextView()
    var moreButton = CustomButton(title: "+")
    var newQueryButton = CustomButton(title: "")
    let startInfoLabel = UILabel()
    
    convenience init() {
        self.init(frame: UIScreen.main.bounds)
        render()
    }

    func render() {
        sv(
            descriptionTextView,
            startInfoLabel,
            topBar,
            moreButton,
            newQueryButton
        )

        backgroundColor = .white

        startInfoLabel.fillHorizontally().fillVertically()
        startInfoLabel.backgroundColor = UIColor(hexString: "D9DADA")
        startInfoLabel.textAlignment = .center
        startInfoLabel.numberOfLines = 3
        startInfoLabel.text = localized("NO WIKIPEDIA\nQUERY YET")
        startInfoLabel.font = SystemFonts.Helvetica_Bold.font(size: 30)

        topBar.fillVertically().fillHorizontally()
        topBar.Bottom == Bottom / 10

        descriptionTextView.Left == Left + 10
        descriptionTextView.Right == Right - 10
        descriptionTextView.Top == topBar.Bottom + 10
        descriptionTextView.Bottom == Bottom - 10
        descriptionTextView.isHidden = true
        descriptionTextView.font = .systemFont(ofSize: 16)
        descriptionTextView.isEditable = false

        moreButton.Right == Right - 20
        moreButton.Bottom == Bottom - 70
        moreButton.Height == Height / 10
        moreButton.Width == moreButton.Height
        moreButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        moreButton.isHidden = true

        newQueryButton.Left == Left + 20
        newQueryButton.Bottom == Bottom - 70
        newQueryButton.Height == Height / 10
        newQueryButton.Width == newQueryButton.Height
        newQueryButton.setImage(TabBarImages.searchImage, for: .normal)

    }

}
