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
import Foundation
import Moya

class WikipediaQuery {
    
    static let provider = MoyaProvider<Wikipedia>()
    
    static private let wikipediaURl = "https://en.wikipedia.org/w/api.php"
    static var query = ""
    static var queryResult = "No Wikipedia query yet."
    static let querySubject = PublishSubject<String>()
    static var queryObservable: Observable<String> {
        return querySubject.asObservable()
    }
    static let queryLength = PublishSubject<Bool>()
    static var queryLengthObservable: Observable<Bool> {
        return queryLength.asObserver()
    }
    static var queries = [SearchQuery]()
    static let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    static func requestInfo(queryString: String, longVersion: Bool, repeatedSearch: Bool = false) {
        guard queryString != "" else { return }
        guard NetworkReachabilityManager()!.isReachable else {
            queryResult = "No internet connection"
            return
        }
        let splittedQueryString = String(queryString.split(separator: "\n")[0]).lowercased()
        WikipediaQuery.provider.request(.queryWithShortResult(splittedQueryString, longVersion)) { result in
            switch result {
            case .success(let response):
                var responseJson = JSON("")
                do {
                    responseJson = JSON(try response.mapJSON())
                } catch {
                    print(error)
                }
                print(responseJson)
                let pageid = responseJson["query"]["pageids"][0].stringValue
                self.queryResult = responseJson["query"]["pages"][pageid]["extract"].stringValue.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
                self.querySubject.onNext(self.queryResult)
                updateResult()
                self.queryLength.onNext(longVersion)
            case .failure:
                print("error")
            }
        }
        
    }
    
    static func save(query: String) {
        let newQuery = SearchQuery(context: self.context)
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let currentDate = formatter.string(from: date)
        
        newQuery.query = query.replacingOccurrences(of: " ", with: "").capitalizingFirstLetter()
        newQuery.date = currentDate
        self.queries.append(newQuery)
        
        do {
            try context.save()
        } catch {
            print("Error saving category \(error)")
        }
    }
    
    static func updateResult() {
        if queryResult == "" {
            self.querySubject.onNext("Sorry, there is no result for this query. :-(")
        } else {
            self.querySubject.onNext(self.queryResult)
        }
    }
    
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
