//
//  TasksTableViewController.swift
//  Tasks
//
//  Created by Austin Potts on 10/14/19.
//  Copyright © 2019 Andrew R Madsen. All rights reserved.
//

import UIKit
import CoreData


class TasksTableViewController: UITableViewController {
    
    var taskController = TaskController()

    // NOTE! This is not a good, efficient way to do this, as the fetch request
    // will be executed every time the tasks property is accessed. We will
    // learn a better way to do this later.
    var tasks: [Task] {
        
        let fetchRequest: NSFetchRequest<Task> =  Task.fetchRequest()
        
        let moc = CoreDataStack.share.mainContext
        
        do {
        let tasks = try moc.fetch(fetchRequest)
            return tasks
        } catch {
            NSLog("Error fetching tasks: \(error)")
            return []
        }
    }
    

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }

    // MARK: - Table view data source



    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tasks.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath)

        cell.textLabel?.text = tasks[indexPath.row].name

        return cell
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        if segue.identifier == "ShowTasksDetail" {
            
            if let detailVC = segue.destination as? TaskDetailViewController,
                let indexPath = tableView.indexPathForSelectedRow {
                
                detailVC.task = tasks[indexPath.row]
                detailVC.taskController = taskController
            } else if segue.identifier == "ShowCreateTask" {
                if let detailVC = segue.destination as? TaskDetailViewController {
                    detailVC.taskController = taskController
                }
            }
        
            
        }
        
        
    }
    

}
