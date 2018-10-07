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
import Moya

class MainViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let provider = MoyaProvider<Wikipedia>()

    let resultSubject = PublishSubject<String>()
    var resultObservable: Observable<String> {
        return resultSubject.asObservable()
    }
    
    let mainView = MainView()
    
    static var staticResult = ""
    
    let classifier = Classifier()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white

        mainView.saveButton.isEnabled = false
        
        view.addSubview(mainView)

        mainView.saveButton.addTarget(self, action: #selector(saveButtonPressed(_:)), for: .touchUpInside)
        mainView.classifyButton.addTarget(self, action: #selector(classifyButtonPressed(_:)), for: .touchUpInside)
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        picker.dismiss(animated: true)
        
        if let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage {
            mainView.imageView.image = image
            guard let ciimage = CIImage(image: image) else {
                fatalError("Could not convert image to CIImage.")
            }
            mainView.resultLabel.text = NSLocalizedString("Processing...", comment: "")
            mainView.resultLabel.backgroundColor = UIColor(hexString: "F9F9F9")
            mainView.startInfoLabel.isHidden = true
            mainView.saveButton.isHidden = false
            DispatchQueue.main.async {
                self.mainView.resultLabel.text = self.classifier.classify(image: ciimage)
                MainViewController.staticResult = self.mainView.resultLabel.text!
                WikipediaQuery.query = self.mainView.resultLabel.text!
                WikipediaQuery.requestInfo(queryString: self.mainView.resultLabel.text!, longVersion: false)
                self.mainView.saveButton.isEnabled = true
            }
        }
    }
    
    func presentPhotoPicker(sourceType: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = sourceType
        present(picker, animated: true)
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        if let image = mainView.imageView.image {
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(save(_:didFinishSavingWithError:contextInfo:)), nil)
        }
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
        let takePhoto = UIAlertAction(title: NSLocalizedString("Take Photo", comment: ""), style: .default) { [unowned self] _ in
            self.presentPhotoPicker(sourceType: .camera)
        }
        let choosePhoto = UIAlertAction(title: NSLocalizedString("Choose Photo", comment: ""), style: .default) { [unowned self] _ in
            self.presentPhotoPicker(sourceType: .photoLibrary)
        }
        
        photoSourcePicker.addAction(takePhoto)
        photoSourcePicker.addAction(choosePhoto)
        photoSourcePicker.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil))
        
        present(photoSourcePicker, animated: true)
    }
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
