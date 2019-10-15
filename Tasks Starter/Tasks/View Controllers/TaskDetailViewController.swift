//
//  TaskDetailViewController.swift
//  Tasks
//
//  Created by Austin Potts on 10/14/19.
//  Copyright © 2019 Andrew R Madsen. All rights reserved.
//

import UIKit

class TaskDetailViewController: UIViewController {

    
    var taskController: TaskController?
    var task: Task?
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var prioritySegmentControl: UISegmentedControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateViews()
        // Do any additional setup after loading the view.
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func save(_ sender: Any) {
        
        if let name = nameTextField.text,
            let notes = notesTextView.text {
            
            if let task = task {
                taskController?.updateTask(task: task, name: name, notes: notes)
            } else {
                taskController?.createTask(with: name, notes: notes, context: CoreDataStack.share.mainContext)
            }
            
        }
        
        navigationController?.popViewController(animated: true)
        
        
    }
    
    func updateViews(){
        
        guard isViewLoaded else{return}
        title = task?.name ?? "Create Task"
        nameTextField.text = task?.name
        notesTextView.text = task?.notes
        
    }
    
}
