//
//  TaskRepresentation.swift
//  Tasks
//
//  Created by Austin Potts on 10/16/19.
//  Copyright © 2019 Andrew R Madsen. All rights reserved.
//

import Foundation
import CoreData


struct TaskRepresentation: Codable {
    
    let name: String
    let notes: String?
    let identifier: UUID
    let priority: String 
    
}
