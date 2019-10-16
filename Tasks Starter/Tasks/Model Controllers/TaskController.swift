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
            
            let tasks = try decoder.decode(<#T##type: Decodable.Protocol##Decodable.Protocol#>, from: <#T##Data#>)
            do {
                
            } catch {
                
            }
            
            
            
        }.resume()
        
        
        
        
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
