//
//  CoreMLModels.swift
//  WhatIsThis
//
//  Created by NVT on 26.04.18.
//  Copyright © 2018 NVT. All rights reserved.
//

import CoreML

struct CoreMLModels {
    var models = [MobileNet().model, GoogLeNetPlaces().model, Inceptionv3().model, GenderNet().model, AgeNet().model]
    var modelNames = ["MobileNet", "GoogLeNetPlaces", "Inceptionv3", "GenderNet", "AgeNet"]

    subscript(index: Int) -> MLModel {
        return models[index]
    }
}
