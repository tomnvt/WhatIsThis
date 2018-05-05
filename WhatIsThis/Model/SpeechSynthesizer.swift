//
//  SpeechSynthesizer.swift
//  WhatIsThis
//
//  Created by NVT on 04.05.18.
//  Copyright © 2018 NVT. All rights reserved.
//

import AVFoundation

class SpeechSynthesizer {
    
    static var speechSynthesizer = AVSpeechSynthesizer()
    
    static func synthesizeSpeech(fromString string: String) {
        let speechUtterance = AVSpeechUtterance(string: string)
        speechSynthesizer.speak(speechUtterance)
    }
    
}
