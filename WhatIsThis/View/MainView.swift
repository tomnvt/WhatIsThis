//
//  MainView.swift
//  WhatIsThis
//
//  Created by NVT on 05.05.18.
//  Copyright © 2018 NVT. All rights reserved.
//

import UIKit
import SwiftRichString
import Stevia

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

    convenience init() {
        self.init(frame: UIScreen.main.bounds)
        render()
    }

    func render() {
        backgroundColor = UIColor(hexString: "D9DADA")

        sv(
            imageView,
            startInfoLabel,
            resultLabel,
            topBar,
            saveButton,
            classifyButton
        )

        imageView.fillVertically().fillHorizontally()
        imageView.contentMode = UIView.ContentMode.scaleAspectFill

        startInfoLabel.fillHorizontally().fillVertically()
        let styleGroup = StyleGroup(base: normal, ["bold": bold])

        startInfoLabel.textAlignment = .center
        startInfoLabel.numberOfLines = 3
        let startInfoText = localized("<bold>TAKE A PHOTO</bold>\nOR\n<bold>CHOOSE ONE</bold>")
        startInfoLabel.attributedText = startInfoText.set(style: styleGroup)

        topBar.fillHorizontally().fillVertically()
        topBar.Bottom == Bottom / 10

        resultLabel.Left == Left + 50
        resultLabel.Right == Right - 50
        resultLabel.Top == topBar.Bottom + 10
        resultLabel.Bottom == Bottom * 0.3
        resultLabel.font = resultLabel.font.withSize(self.frame.height / 25)

        classifyButton.Left == Left + 20
        classifyButton.Bottom == Bottom - 100
        classifyButton.Height == Height * 0.1
        classifyButton.Width == saveButton.Height
        classifyButton.setImage(TabBarImages.cameraImage, for: .normal)

        saveButton.Right == Right - 20
        saveButton.Bottom == Bottom - 100
        saveButton.Height == Height * 0.1
        saveButton.Width == saveButton.Height
        saveButton.isHidden = true

    }

}
