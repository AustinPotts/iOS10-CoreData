//
//  Task+Convenience.swift
//  Tasks
//
//  Created by Austin Potts on 10/14/19.
//  Copyright © 2019 Andrew R Madsen. All rights reserved.
//

import Foundation
import CoreData



extension Task {
    
    
    
    
    //This initializer sets up the core data (NSManagedObjectContext) part of the Task, then gives it the properties unique to the model
    @discardableResult convenience init(name: String, notes: String, context: NSManagedObjectContext) {
        
        self.init(context: context)
        
        self.name = name
        self.notes = notes
        
        
    }
    
    
    
    
    
    
}
