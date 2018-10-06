//
//  Wikipedia.swift
//  WhatIsThis
//
//  Created by NVT on 06/10/2018.
//  Copyright © 2018 NVT. All rights reserved.
//

import Foundation
import Moya

public enum Wikipedia {
    case queryWithShortResult(String, Bool)
}

extension Wikipedia: TargetType {

    public var baseURL: URL {
        return URL(string: "https://en.wikipedia.org/w/api.php")!
    }

    public var path: String {
        switch self {
        case .queryWithShortResult: return ""
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .queryWithShortResult: return .get
        }
    }
    
    public var sampleData: Data {
        return Data()
    }
    
    public var task: Task {
        switch self {
        case .queryWithShortResult(let queryString, let longQuery):
            if longQuery == false {
                return .requestParameters( parameters:
                    ["format" : "json",
                     "action" : "query",
                     "prop" : "extracts|pageimages",
                     "exintro" : "",
                     "explaintext" : "",
                     "titles" : queryString,
                     "redirects" : "1",
                     "pithumbsize" : "500",
                     "indexpageids" : ""],
                                           encoding: URLEncoding.default)
            } else {
                return .requestParameters( parameters:
                ["action" : "query",
                 "prop" : "extracts",
                 "meta" : "siteinfo",
                 "titles" : queryString,
                 "format" : "json",
                 "indexpageids" : ""],
                    encoding: URLEncoding.default)
            }
        }
    }
    
    public var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
    
}
