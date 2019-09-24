//
//  DataSource+Goals.swift
//  Bold
//
//  Created by Alexander Kovalov on 9/3/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import CoreData

protocol GoalsFunctionality {
    func createNewGoal()
    func updateGoal()
    func deleteGoal()
    func goalsList() -> [Goal]
}

extension DataSource: GoalsFunctionality {
    func createNewGoal() {
        
    }
    
    func updateGoal() {
        
    }
    
    func deleteGoal() {
        
    }
    
    func goalsList() -> [Goal] {
        
        var results = [Goal]()
        let fetchRequest = NSFetchRequest<Goal>(entityName: "Goal")
        do {
            results = try DataSource.shared.backgroundContext.fetch(fetchRequest)
        } catch {
            print(error)
        }
        
        return results
    }
}
