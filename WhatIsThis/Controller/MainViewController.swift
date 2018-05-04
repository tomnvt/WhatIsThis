//
//  ViewController.swift
//  WhatIsThis
//
//  Created by NVT on 02.04.18.
//  Copyright © 2018 NVT. All rights reserved.
//

import UIKit
import ImageIO
import SnapKit

protocol ShowDescriptionDelegate {
    func show(description: String)
}

class MainViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var wikiButton = UIBarButtonItem(title: "Wiki", style: .plain, target: nil, action: #selector(wikiButtonPressed))
    var settingsButton = UIBarButtonItem(title: "Settings", style: .plain, target: nil, action: #selector(settingsButtonPresed))
    
    var saveButton = MainScreenButton(title: "Save")
    var classifyButton = MainScreenButton(title: "Classify")
    var imageView = UIImageView()
    var resultLabel = ResultLabel()
    
    var image = UIImage()
    let imagePicker = UIImagePickerController()
    
    let wikipediaQuery = WikipediaQuery()
    let classifier = Classifier()
    
    var delegate : ShowDescriptionDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "What is this?"
        
        view.backgroundColor = .white

        navigationItem.leftBarButtonItem = wikiButton
        navigationItem.rightBarButtonItem = settingsButton
        
        wikiButton.target = self
        settingsButton.target = self
        
        wikiButton.tag = 0
        settingsButton.tag = 1
        
        wikiButton.isEnabled = false
        saveButton.isEnabled = false
        
        view.addSubview(saveButton)
        saveButton.snp.makeConstraints( { (make) -> Void in
            make.right.equalTo(view.snp.right).dividedBy(2).inset(10)
            make.left.equalToSuperview().offset(20)
            make.height.equalTo(view.snp.height).dividedBy(15)
            make.bottom.equalToSuperview().inset(20)
        })
        saveButton.addTarget(self, action: #selector(saveButtonPressed(_:)), for: .touchUpInside)
        
        view.addSubview(classifyButton)
        classifyButton.snp.makeConstraints( { (make) -> Void in
            make.right.equalToSuperview().inset(20)
            make.left.equalTo(view.snp.right).dividedBy(2).offset(10)
            make.height.equalTo(view.snp.height).dividedBy(15)
            make.bottom.equalToSuperview().inset(20)
        })
        classifyButton.addTarget(self, action: #selector(classifyButtonPressed(_:)), for: .touchUpInside)

        view.addSubview(imageView)
        imageView.snp.makeConstraints( { (make) -> Void in
            make.right.left.equalToSuperview()
            make.height.equalTo(view.snp.height).dividedBy(2)
            make.bottom.equalTo(view.snp.bottom).dividedBy(1.2)
        })
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        
        view.addSubview(resultLabel)
        resultLabel.snp.makeConstraints( { (make) -> Void in
            make.right.left.equalToSuperview()
            make.top.equalToSuperview().offset(view.frame.height / 10)
            make.bottom.equalTo(imageView.snp.top)
        })
        resultLabel.font = resultLabel.font.withSize(view.frame.height / 25)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true)
        resultLabel.text = "Processing..."
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
            guard let ciimage = CIImage(image: image) else {
                fatalError("Could not convert image to CIImage.")
            }
            DispatchQueue.main.async {
                self.resultLabel.text = self.classifier.classify(image: ciimage)
                self.wikipediaQuery.requestInfo(result: self.resultLabel.text!)
                self.wikiButton.isEnabled = true
                self.saveButton.isEnabled = true
            }
        }
    }
    
    func presentPhotoPicker(sourceType: UIImagePickerControllerSourceType) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = sourceType
        present(picker, animated: true)
    }
    
    @IBAction func wikiButtonPressed() {
        let vc = WikipediaQueryViewController()
        delegate = vc
        vc.show(description: wikipediaQuery.queryResult)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func settingsButtonPresed() {
        let vc = SettingsTableTableViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(save(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func save(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        print("trying to save")
        if let error = error {
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    @IBAction func classifyButtonPressed(_ sender: UIButton) {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            presentPhotoPicker(sourceType: .photoLibrary)
            return
        }
        
        let photoSourcePicker = UIAlertController()
        let takePhoto = UIAlertAction(title: "Take Photo", style: .default) { [unowned self] _ in
            self.presentPhotoPicker(sourceType: .camera)
        }
        let choosePhoto = UIAlertAction(title: "Choose Photo", style: .default) { [unowned self] _ in
            self.presentPhotoPicker(sourceType: .photoLibrary)
        }
        
        photoSourcePicker.addAction(takePhoto)
        photoSourcePicker.addAction(choosePhoto)
        photoSourcePicker.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(photoSourcePicker, animated: true)
    }
}
