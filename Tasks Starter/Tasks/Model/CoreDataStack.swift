//
//  CoreDataStack.swift
//  Tasks
//
//  Created by Austin Potts on 10/14/19.
//  Copyright © 2019 Andrew R Madsen. All rights reserved.
//

import Foundation
import CoreData


class CoreDataStack {
    
    // Let us access the CoreDataStack from anywhere in the APP
    static let share = CoreDataStack()
    
    private init() {
        
    }
    
    
    
    //Building the container
    // Creating only one instance for use
    lazy var container: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "Tasks")
        
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error {
                fatalError("Error loading Persistent Stores: \(error)")
            }
        })
        return container
    }()
    
    
    //Create easy access to the moc (managed object context)
    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }
    
    
    //Save to persistent store
    func saveToPersistentStore() {
        do{
            try mainContext.save()
        } catch {
            NSLog("Error saving context \(error)")
            mainContext.reset()
        }
    }
    
    
}

