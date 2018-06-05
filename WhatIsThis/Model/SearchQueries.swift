//
//  Queries.swift
//  WhatIsThis
//
//  Created by NVT on 03.06.18.
//  Copyright © 2018 NVT. All rights reserved.
//

import UIKit
import CoreData

class SearchQueries {
    
    var queries = [SearchQuery]()
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    init() {
        loadQueries()
        getQueriesByDate()
    }
    
    //: MARK: - Method for loading all saved queries from the context
    
    func loadQueries() {
        let request : NSFetchRequest<SearchQuery> = SearchQuery.fetchRequest()
        do{
            queries = try context.fetch(request)
        } catch {
            print("Error loading queriws \(error)")
        }
    }
    
    //: MARK: - Method for removing all saved queries from the context
    
    @IBAction func clearQueries() {
        for query in self.queries {
            self.context.delete(query)
        }
        loadQueries()
    }
    
    func getQueriesByDate() -> [String: [String]] {
        var dates = Set<String>()
        var queriesByDate = [String: [String]]()
        for item in queries {
            dates.insert(item.date!)
        }
        for date in dates {
            var queriesForGivenDate = [String]()
            for item in queries {
                if item.date == date {
                    queriesForGivenDate.append(item.query!)
                }
            }
            queriesByDate[date] = queriesForGivenDate
        }
        return queriesByDate
    }
    
}
