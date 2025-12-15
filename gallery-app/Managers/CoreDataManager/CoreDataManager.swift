//
//  CoreDataManager.swift
//  gallery-app
//
//  Created by Pavel Playerz0redd on 14.12.25.
//

import CoreData

final class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    private init() { }
    
    lazy private var persistanceContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "PhotoEntity")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError(error.localizedDescription)
            }
        }
        return container
    }()
    
    private var context: NSManagedObjectContext {
        persistanceContainer.viewContext
    }
    
   
}
