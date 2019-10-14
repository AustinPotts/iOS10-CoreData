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
    
    convenience init(name: String, notes: String, context: NSManagedObjectContext) {
        
        self.init(context: context)
        
        self.name = name
        self.notes = notes
        
        
        
    }
    
    
    
    
    
    
}
