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

protocol SendDescriptionDelegate {
    func sendDescription()
}

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var wikiButton: UIBarButtonItem!
    
    let imagePicker = UIImagePickerController()
    var classificationResults : [VNClassificationObservation] = []
    var speechSynthesizer = AVSpeechSynthesizer()
    let wikipediaURl = "https://en.wikipedia.org/w/api.php"
    var imageDescription = "XXX"
    
    var delegate : SendDescriptionDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        wikiButton.isEnabled = false
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
            }
        }
    }
    
    @IBAction func takePicture() {
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
    
    
    @IBAction func wikiButtonPressed(_ sender: UIBarButtonItem) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ResultsViewController") as! ResultsViewController
        self.present(vc, animated: true, completion: nil)
        vc.sendDescription(text: imageDescription)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "goToWikiResult" {
//            let vc = segue.destination as! ResultsViewController
//            delegate = vc
//            vc.sendDescription(text: "XXL")
//        }
//    }
}

extension ViewController {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        picker.dismiss(animated: true)
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageView.image = image
        updateClassifications(for: image)
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

