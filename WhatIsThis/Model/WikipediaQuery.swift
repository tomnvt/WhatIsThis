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
    
    static private let wikipediaURl = "https://en.wikipedia.org/w/api.php"
    static var query = ""
    static var queryResult = "No Wikipedia query yet."
    static let querySubject = PublishSubject<String>()
    static var queryObservable: Observable<String> {
        return querySubject.asObservable()
    }
    static var queries = [SearchQuery]()
    static let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    static func requestInfo(result: String, longVersion: Bool) {
        guard result != "" else { return }
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
                    print("Result:")
                    print(queryResult)
                }
                if !longVersion {
                    save(query: result)
                }
            }
        } else {
            queryResult = "No internet connection"
        }
    }
    
    static func save(query: String) {
        let newQuery = SearchQuery(context: self.context)
        newQuery.query = query
        self.queries.append(newQuery)
        
        do {
            try context.save()
            print("Saved \(String(describing: newQuery.query))")
        } catch {
            print("Error saving category \(error)")
        }
    }
}
