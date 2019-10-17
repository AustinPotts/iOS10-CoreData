//
//  TaskController.swift
//  Tasks
//
//  Created by Austin Potts on 10/14/19.
//  Copyright © 2019 Andrew R Madsen. All rights reserved.
//

import Foundation
import CoreData

enum HTTPMethod: String{
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
}


class TaskController {
    
     let baseURL = URL(string: "https://tasks-3f211.firebaseio.com/")!
    
    ///Using this iniitialzier for the 'View Did load' of the Controller
    init() {
        fetchTaskFromServer()
    }
    
    //Fetch
    
    func fetchTaskFromServer(completion: @escaping ()-> Void = { } ){
        
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
        
        let context = CoreDataStack.share.container.newBackgroundContext()
        
        context.performAndWait {
            
        
        
        do {
            
            
            let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
            
            //Only fetch the tasks with identifiers that are in this identifersToFetch array
            fetchRequest.predicate = NSPredicate(format: "identifier IN %@", identifiersToFetch)
            
            
            
            // We need to run the context.fetch on the main queue, because the context is the main context
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
                
                
            
            CoreDataStack.share.save(context: context)
        } catch {
            NSLog("Error fetching tasks from persistence store: \(error)")
            
         }
        }
       
    }
    
    func putTask(task: Task, completion: @escaping ()-> Void = { }){
        
        //Find a unique place to put this task
        let identifier = task.identifier ?? UUID()
        task.identifier = identifier
        
        let requestURL = baseURL
            .appendingPathComponent(identifier.uuidString)
            .appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.put.rawValue
        
        guard let taskRepresentation = task.taskRepresentation else {
            NSLog("Task Representation is nil")
            completion()
            return
        }
        
        do {
            request.httpBody = try JSONEncoder().encode(taskRepresentation)
        } catch {
            NSLog("Error encoding task representation: \(error)")
            completion()
            return
        }
        
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            
            if let error = error {
                NSLog("Error PUTting task: \(error)")
                completion()
                return
            }
            
            completion()
            }.resume()
        
        
        
    }
    
    
    //CRUD
    func createTask(with name: String, notes: String, priority: TaskPriority, context: NSManagedObjectContext) {
    
        let task = Task(name: name, notes: notes, priority: priority, context: context)
        
        
        CoreDataStack.share.save()
        putTask(task: task)
        
    }
    
    func updateTask(task: Task, name: String, notes: String, priority: TaskPriority) {
        task.name = name
        task.notes = notes
        task.priority = priority.rawValue
        
        CoreDataStack.share.save()
        putTask(task: task)
        
    }
    
    func delete(task: Task) {
        CoreDataStack.share.mainContext.delete(task)
        CoreDataStack.share.save()
    }
    
    
    
    
    
}
