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
    
    
    var taskRepresentation: TaskRepresentation? {
        
        guard let name = name,
        let priority = priority,
            let identifier = identifier else{return nil }
        
        return TaskRepresentation(name: name, notes: notes, identifier: identifier, priority: priority)
        
    }
    
    
    //This initializer sets up the core data (NSManagedObjectContext) part of the Task, then gives it the properties unique to the model
    @discardableResult convenience init(name: String, notes: String?, priority: TaskPriority, identifier: UUID = UUID(), context: NSManagedObjectContext) {
        
        self.init(context: context)
        
        self.name = name
        self.notes = notes
        self.priority = priority.rawValue
        self.identifier = identifier
        
        
    }
    
    
    @discardableResult convenience init?(taskRepresentation: TaskRepresentation, context: NSManagedObjectContext){
        
        guard let priority = TaskPriority(rawValue: taskRepresentation.priority) else {return nil}
        
        self.init(name: taskRepresentation.name,
                  notes: taskRepresentation.notes,
                  priority: priority,
                  identifier: taskRepresentation.identifier,
                  context: context)
        
        
    }
    
    
    
    
}
