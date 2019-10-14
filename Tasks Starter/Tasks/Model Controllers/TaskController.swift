//
//  TaskController.swift
//  Tasks
//
//  Created by Austin Potts on 10/14/19.
//  Copyright © 2019 Andrew R Madsen. All rights reserved.
//

import Foundation
import CoreData


class TaskController {
    
    //CRUD
    func createTask(with name: String, notes: String, context: NSManagedObjectContext) {
    
        Task(name: name, notes: notes, context: context)
        CoreDataStack.share.saveToPersistentStore()
        
    }
    
    func updateTask(task: Task, name: String, notes: String) {
        task.name = name
        task.notes = notes
        
        CoreDataStack.share.saveToPersistentStore()
        
    }
    
    
    
    
    
}
