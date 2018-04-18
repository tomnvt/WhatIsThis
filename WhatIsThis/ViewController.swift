//
//  ViewController.swift
//  WhatIsThis
//
//  Created by NVT on 02.04.18.
//  Copyright © 2018 NVT. All rights reserved.
//

import UIKit
import CoreML
import Vision
import ImageIO
import AVFoundation
import Alamofire
import SwiftyJSON

protocol ShowDescriptionDelegate {
    func show(description: String)
}

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var wikiButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIButton!
    
    var image = UIImage()
    let imagePicker = UIImagePickerController()
    var classificationResults : [VNClassificationObservation] = []
    var speechSynthesizer = AVSpeechSynthesizer()
    let wikipediaURl = "https://en.wikipedia.org/w/api.php"
    var imageDescription = "Nothing classified yet"
    
    var delegate : ShowDescriptionDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveButton.isEnabled = false
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true)
            image = info[UIImagePickerControllerOriginalImage] as! UIImage
            imageView.image = image
            updateClassifications(for: image)
    }
    
    lazy var classificationRequest: VNCoreMLRequest = {
        do {
            let model = try VNCoreMLModel(for: MobileNet().model)
            
            let request = VNCoreMLRequest(model: model, completionHandler: { [weak self] request, error in
                self?.processClassifications(for: request, error: error)
            })
            request.imageCropAndScaleOption = .centerCrop
            return request
        } catch {
            fatalError("Failed to load Vision ML model: \(error)")
        }
    }()
    
    func updateClassifications(for image: UIImage) {
        print("Classifying...")
        
        let orientation = CGImagePropertyOrientation(image.imageOrientation)
        guard let ciImage = CIImage(image: image) else { fatalError("Unable to create \(CIImage.self) from \(image).") }
        
        DispatchQueue.global(qos: .userInitiated).async {
            let handler = VNImageRequestHandler(ciImage: ciImage, orientation: orientation)
            do {
                try handler.perform([self.classificationRequest])
            } catch {
                print("Failed to perform classification.\n\(error.localizedDescription)")
            }
        }
    }
    
    func processClassifications(for request: VNRequest, error: Error?) {
        DispatchQueue.main.async {
            guard let results = request.results else {
                print("Unable to classify image.\n\(error!.localizedDescription)")
                return
            }
            let classifications = results as! [VNClassificationObservation]
            
            if classifications.isEmpty {
                print("Nothing recognized.")
            } else {
                let topClassifications = classifications.prefix(2)
                let descriptions = topClassifications.map { classification in
                    return String(format: "  (%.2f) %@", classification.confidence, classification.identifier)
                }
                
                let result = String(descriptions[0].split(separator: ",")[0].split(separator: ")")[1])
                let resultUppercased = result.uppercased()
                let rawPercentage = String(descriptions[0].split(separator: ",")[0].split(separator: " ")[0])
                let start = rawPercentage.index(rawPercentage.startIndex, offsetBy: 3)
                let end = rawPercentage.index(rawPercentage.endIndex, offsetBy: -1)
                let range = start..<end
                let percentage = rawPercentage[range] + " %"
                print(percentage)
                self.resultLabel.text = resultUppercased + "\n" + percentage
                print(descriptions)
                let resultSentence = "This looks like a \(result).  I'm \(percentage) sure."
                self.synthesizeSpeech(fromString: resultSentence)
                self.requestInfo(result: result)
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
    
    func synthesizeSpeech(fromString string: String) {
        let speechUtterance = AVSpeechUtterance(string: string)
        speechSynthesizer.speak(speechUtterance)
    }
    
    func requestInfo(result: String) {
        let parameters : [String:String] = ["format" : "json", "action" : "query", "prop" : "extracts|pageimages", "exintro" : "", "explaintext" : "", "titles" : result, "redirects" : "1", "pithumbsize" : "500", "indexpageids" : ""]
        
        Alamofire.request(wikipediaURl, method: .get, parameters: parameters).responseJSON { (response) in
            if response.result.isSuccess {
                
                print("Success! Got the  data")
                let wikiJSON : JSON = JSON(response.result.value!)
                let pageid = wikiJSON["query"]["pageids"][0].stringValue
                self.imageDescription = wikiJSON["query"]["pages"][pageid]["extract"].stringValue
                print("Description: \(self.imageDescription)")
                self.wikiButton.isEnabled = true
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! ResultsViewController
        delegate = vc
        vc.show(description: imageDescription)
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(save(_:didFinishSavingWithError:contextInfo:)), nil)
        
    }
    
    @objc func save(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        print("trying to save")
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
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


extension CGImagePropertyOrientation {
    init(_ orientation: UIImageOrientation) {
        switch orientation {
        case .up: self = .up
        case .upMirrored: self = .upMirrored
        case .down: self = .down
        case .downMirrored: self = .downMirrored
        case .left: self = .left
        case .leftMirrored: self = .leftMirrored
        case .right: self = .right
        case .rightMirrored: self = .rightMirrored
        }
    }
}

