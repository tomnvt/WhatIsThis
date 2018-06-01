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

class MainViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let resultSubject = PublishSubject<String>()
    var resultObservable: Observable<String> {
        return resultSubject.asObservable()
    }
    
    let mainView = MainView()
    
    var result = ""
    
    let classifier = Classifier()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white

        mainView.saveButton.isEnabled = false
        
        view.addSubview(mainView)

        mainView.saveButton.addTarget(self, action: #selector(saveButtonPressed(_:)), for: .touchUpInside)
        mainView.classifyButton.addTarget(self, action: #selector(classifyButtonPressed(_:)), for: .touchUpInside)
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true)
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            mainView.imageView.image = image
            guard let ciimage = CIImage(image: image) else {
                fatalError("Could not convert image to CIImage.")
            }
            mainView.resultLabel.text = "Processing..."
            mainView.resultLabel.backgroundColor = UIColor(hexString: "F9F9F9")
            mainView.startInfo.isHidden = true
            mainView.saveButton.isHidden = false
            DispatchQueue.main.async {
                self.mainView.resultLabel.text = self.classifier.classify(image: ciimage)
                WikipediaQuery.query = self.result
                WikipediaQuery.requestInfo(result: self.mainView.resultLabel.text!, longVersion: false)
                self.mainView.saveButton.isEnabled = true
                self.resultSubject.onNext(self.result)
            }
        }
    }
    
    func presentPhotoPicker(sourceType: UIImagePickerControllerSourceType) {
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
