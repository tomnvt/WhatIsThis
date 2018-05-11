//
//  WikipediaQuery.swift
//  WhatIsThis
//
//  Created by NVT on 19.04.18.
//  Copyright © 2018 NVT. All rights reserved.
//

import Alamofire
import SwiftyJSON
import RxSwift

class WikipediaQuery {
    
    private let wikipediaURl = "https://en.wikipedia.org/w/api.php"
    var queryResult = "No Wikipedia query yet."
    let querySubject = PublishSubject<String>()
    var queryObservable: Observable<String> {
        return querySubject.asObservable()
    }
    
    func requestInfo(result: String, longVersion: Bool) {
        let result = String(result.split(separator: "\n")[0]).lowercased()
        let parametersShortQuery : [String:String] = ["format" : "json",
                                                      "action" : "query",
                                                      "prop" : "extracts|pageimages",
                                                      "exintro" : "",
                                                      "explaintext" : "",
                                                      "titles" : result,
                                                      "redirects" : "1",
                                                      "pithumbsize" : "500",
                                                      "indexpageids" : ""]
        
        let parametersLongQuery : [String:String] = ["action" : "query",
                                                     "prop" : "extracts",
                                                     "meta" : "siteinfo",
                                                     "titles" : result,
                                                     "format" : "json",
                                                     "indexpageids" : ""]
        

        if NetworkReachabilityManager()!.isReachable {
            
            let parameters = longVersion ? parametersLongQuery : parametersShortQuery
            
            Alamofire.request(wikipediaURl, method: .get, parameters: parameters).responseJSON { (response) in
                if response.result.isSuccess {
                    let wikiJSON : JSON = JSON(response.result.value!)
                    let pageid = wikiJSON["query"]["pageids"][0].stringValue
                    self.queryResult = wikiJSON["query"]["pages"][pageid]["extract"].stringValue.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
                    self.querySubject.onNext(self.queryResult)
                }
            }
        } else {
            queryResult = "No internet connection"
        }
    }
    
}
