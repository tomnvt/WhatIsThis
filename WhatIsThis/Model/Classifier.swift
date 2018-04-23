//
//  Classifier.swift
//  WhatIsThis
//
//  Created by NVT on 20.04.18.
//  Copyright © 2018 NVT. All rights reserved.
//

import UIKit
import CoreML
import Vision
import AVFoundation

class Classifier {
    
    lazy var speechSynthesizer = AVSpeechSynthesizer()
    let defaults = UserDefaults.standard
    
    func classify(image: CIImage) -> String {
        var result = ""
        guard let model = try? VNCoreMLModel(for: MobileNet().model) else {
            fatalError("Failed to load MobileNet model.")
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let classifications = request.results as? [VNClassificationObservation] else {
                fatalError("Model failed to process image.")
            }
            let topClassifications = classifications.prefix(2)
            let descriptions = topClassifications.map { classification in
                return String(format: "  (%.2f) %@", classification.confidence, classification.identifier)
            }
            let requestResult = String(descriptions[0].split(separator: ",")[0].split(separator: ")")[1])
            let resultUppercased = requestResult.uppercased()
            let rawPercentage = String(descriptions[0].split(separator: ",")[0].split(separator: " ")[0])
            let start = rawPercentage.index(rawPercentage.startIndex, offsetBy: 3)
            let end = rawPercentage.index(rawPercentage.endIndex, offsetBy: -1)
            let range = start..<end
            let percentage = rawPercentage[range] + " %"
            result = resultUppercased + "\n" + percentage
            
            let resultSentence = "This looks like a \(requestResult).  I'm \(percentage) sure."
            if self.defaults.bool(forKey: "speechSynthesisIsOn") == true {
                self.synthesizeSpeech(fromString: resultSentence)
            }
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        
        do {
            try handler.perform([request])
            return result
        }
        catch {
            print(error)
        }
        return result
    }
    
    
    func synthesizeSpeech(fromString string: String) {
        let speechUtterance = AVSpeechUtterance(string: string)
        speechSynthesizer.speak(speechUtterance)
    }
    
}
