//
//  AppDelegate.swift
//  WhatIsThis
//
//  Created by NVT on 02.04.18.
//  Copyright © 2018 NVT. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let tabBarController = MainTabBarController()
        
        let mainViewController = MainViewController(nibName: nil, bundle: nil)
        let wikipediaQueryViewController = WikipediaQueryViewController(nibName: nil, bundle: nil)
        let queryHistoryTableViewController = QueryHistoryTableViewController(nibName: nil, bundle: nil)
        let settingsTableViewController = SettingsTableTableViewController(nibName: nil, bundle: nil)
        
        mainViewController.tabBarItem = UITabBarItem(title: NSLocalizedString("What is this?", comment: ""), image: TabBarImages.searchImage, tag: 0)
        wikipediaQueryViewController.tabBarItem = UITabBarItem(title: NSLocalizedString("Wikipedia", comment: ""), image: TabBarImages.wikipediaImage, tag: 1)
        queryHistoryTableViewController.tabBarItem = UITabBarItem(title: NSLocalizedString("History", comment: ""), image: TabBarImages.historyImage, tag: 2)
        settingsTableViewController.tabBarItem = UITabBarItem(title: NSLocalizedString("Settings", comment: ""), image: TabBarImages.settingsImage, tag: 3)
        
        tabBarController.viewControllers = [mainViewController,
                                            wikipediaQueryViewController,
                                            queryHistoryTableViewController,
                                            settingsTableViewController]

        self.window!.rootViewController = tabBarController
        self.window?.makeKeyAndVisible()
        
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        self.saveContext()
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "SearchHistory")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }


}

