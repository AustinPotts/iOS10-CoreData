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
    func createTask(with name: String, notes: String, priority: TaskPriority, context: NSManagedObjectContext) {
    
        Task(name: name, notes: notes, priority: priority, context: context)
        
        CoreDataStack.share.saveToPersistentStore()
        
    }
    
    func updateTask(task: Task, name: String, notes: String, priority: TaskPriority) {
        task.name = name
        task.notes = notes
        task.priority = priority.rawValue
        
        CoreDataStack.share.saveToPersistentStore()
        
    }
    
    
    
    
    
}
