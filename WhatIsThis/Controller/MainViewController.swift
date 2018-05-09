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
import RxSwift

protocol ShowDescriptionDelegate {
    func show(description: String)
}

class MainViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var wikiButton = UIBarButtonItem(title: "Wiki", style: .plain, target: nil, action: #selector(wikiButtonPressed))
    var settingsButton = UIBarButtonItem(title: "Settings", style: .plain, target: nil, action: #selector(settingsButtonPresed))

    let mainView = MainView()
    
    var image = UIImage()
    let imagePicker = UIImagePickerController()
    
    let wikipediaQuery = WikipediaQuery()
    let classifier = Classifier()
    
    var delegate : ShowDescriptionDelegate?
    
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "What is this?"
        
        view.backgroundColor = .white

        navigationItem.leftBarButtonItem = wikiButton
        navigationItem.rightBarButtonItem = settingsButton
        
        wikiButton.target = self
        settingsButton.target = self
        
        wikiButton.isEnabled = false
        mainView.saveButton.isEnabled = false
        
        view.addSubview(mainView)

        mainView.saveButton.addTarget(self, action: #selector(saveButtonPressed(_:)), for: .touchUpInside)
        mainView.classifyButton.addTarget(self, action: #selector(classifyButtonPressed(_:)), for: .touchUpInside)
        
        wikipediaQuery.queryObservable
            .subscribe({_ in
                self.wikiButton.isEnabled = true
            })
            .disposed(by: bag)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true)
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            mainView.imageView.image = image
            guard let ciimage = CIImage(image: image) else {
                fatalError("Could not convert image to CIImage.")
            }
            self.wikiButton.isEnabled = false
            mainView.resultLabel.text = "Processing..."
            DispatchQueue.main.async {
                self.mainView.resultLabel.text = self.classifier.classify(image: ciimage)
                self.wikipediaQuery.requestInfo(result: self.mainView.resultLabel.text!, longVersion: false)
                self.mainView.saveButton.isEnabled = true
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
