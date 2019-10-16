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
    
     let baseURL = URL(string: "https://tasks-3f211.firebaseio.com/")!
    
    //Fetch
    
    func fetchTaskFromServer(completion: @escaping ()-> Void){
        
        //Set up the URL
        let requestURL = baseURL.appendingPathExtension("json")
        
        //Create the URLRequest
        var request = URLRequest(url: requestURL)
        
        //Perform Data Task
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            
            if let error = error {
                NSLog("Error fetching tasks: \(error)")
                completion()
                return
            }
            
            guard let data = data else {
                NSLog("Error fetchign data")
                completion()
                return
            }
            
            
            let decoder = JSONDecoder()
            
            
            do {
                let tasks = try decoder.decode([String: TaskRepresentation].self, from: data).map({ $0.value })
                
               self.updateTasks(with: tasks)
                
            } catch {
                NSLog("Error decoding TaskRep: \(error)")
                
            }
            
            completion()
            
        }.resume()
        
    }
    
    
    func updateTasks(with representations: [TaskRepresentation]){
        
        // Which representations do we already have in core data
        
        let identifiersToFetch = representations.map({ $0.identifier })
        
        let representationsByID = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, representations))
        
        //Make a mutable copy of the Dictionary above
        var tasksToCreate = representationsByID
        
        do {
            let context = CoreDataStack.share.mainContext
            
            let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
            
            //Only fetch the tasks with identifiers that are in this identifersToFetch array
            fetchRequest.predicate = NSPredicate(format: "identifier IN %@", identifiersToFetch)
            
            let exisitingTasks = try context.fetch(fetchRequest)
            
            //Update the ones we have
            for task in exisitingTasks {
                
                // Grab the task representation that corresponds to this task
                guard let identifier = task.identifier,
                    let representation = representationsByID[identifier]else { continue }
                
                task.name = representation.name
                task.notes = representation.notes
                task.priority = representation.priority
                
                //We just updated a Task, we dont need to create a new Task for this identifier
                tasksToCreate.removeValue(forKey: identifier)
             }
                
                //Figure out which We dont have
                for representation in tasksToCreate.values {
                    
                    Task(taskRepresentation: representation, context: context)
                }
                
                
            
            CoreDataStack.share.saveToPersistentStore()
        } catch {
            NSLog("Error fetching tasks from persistence store: \(error)")
            
        }
        
       
    }
    
    
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
