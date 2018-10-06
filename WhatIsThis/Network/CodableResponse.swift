//
//  CodableResponse.swift
//  WhatIsThis
//
//  Created by NVT on 06/10/2018.
//  Copyright © 2018 NVT. All rights reserved.
//

import Foundation

struct WikipediaResponse<T: Codable>: Codable {
    let data: WikipediaResults<T>
}

struct WikipediaResults<T: Codable>: Codable {
    let results: [T]
}
