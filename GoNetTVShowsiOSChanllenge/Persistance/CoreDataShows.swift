//
//  CoreDataSticker.swift
//  Publisher-msp
//
//  Created by Martín Serrano on 11/26/17.
//  Copyright © 2017 Inclan. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManagerShows {
    
    static let shared = CoreDataManagerShows()
    
    lazy var storesDirectory: URL = {
        let fm = FileManager.default
        let urls = fm.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var localStoreURL: URL = {
        let url = self.storesDirectory.appendingPathComponent("CoreDataStack.sqlite")
        return url
    }()
    
    lazy var modelURL: URL = {
        let bundle = Bundle.main
        guard let url = bundle.url(forResource: "Shows", withExtension: "momd") else {
            print("CRITICAL - Managed Object Model file not found")
            abort()
        }
        return url
    }()
    
    lazy var model: NSManagedObjectModel = {
        return NSManagedObjectModel(contentsOf: self.modelURL)
        }()!
    
    lazy var coordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.model)
        do{
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: self.localStoreURL, options: nil)
        }catch {
            print("Could not add the persistent Store")
            abort()
        }
        return coordinator
    }()
}
