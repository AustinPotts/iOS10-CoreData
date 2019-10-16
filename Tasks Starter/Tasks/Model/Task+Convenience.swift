//
//  Task+Convenience.swift
//  Tasks
//
//  Created by Austin Potts on 10/14/19.
//  Copyright © 2019 Andrew R Madsen. All rights reserved.
//

import Foundation
import CoreData

enum TaskPriority: String, CaseIterable {
    case low
    case normal
    case high
    case critical
}


extension Task {
    
    
    
    
    //This initializer sets up the core data (NSManagedObjectContext) part of the Task, then gives it the properties unique to the model
    @discardableResult convenience init(name: String, notes: String, priority: TaskPriority, identifier: UUID = UUID(), context: NSManagedObjectContext) {
        
        self.init(context: context)
        
        self.name = name
        self.notes = notes
        self.priority = priority.rawValue
        self.identifier = identifier
        
        
    }
    
    
    
    
    
    
}
