//
//  WikipediaQuery.swift
//  WhatIsThis
//
//  Created by NVT on 19.04.18.
//  Copyright © 2018 NVT. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class WikipediaQuery {
    
    private let wikipediaURl = "https://en.wikipedia.org/w/api.php"
    var queryResult = "nothing classified yet"
    
    func requestInfo(result: String) {
        let parameters : [String:String] = ["format" : "json", "action" : "query", "prop" : "extracts|pageimages", "exintro" : "", "explaintext" : "", "titles" : result, "redirects" : "1", "pithumbsize" : "500", "indexpageids" : ""]
        
        Alamofire.request(wikipediaURl, method: .get, parameters: parameters).responseJSON { (response) in
            if response.result.isSuccess {
                
                print("Success! Got the  data")
                let wikiJSON : JSON = JSON(response.result.value!)
                let pageid = wikiJSON["query"]["pageids"][0].stringValue
                self.queryResult = wikiJSON["query"]["pages"][pageid]["extract"].stringValue
            }
        }
    }
    
}
