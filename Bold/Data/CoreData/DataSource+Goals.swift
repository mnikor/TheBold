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
    func goalsListForUpdate() -> [Goal]
}

extension DataSource: GoalsFunctionality {
    func createNewGoal() {
        
    }
    
    func updateGoal() {
        
    }
    
    func deleteGoal() {
        
    }
    
    func goalsListForUpdate() -> [Goal] {
        
        var results = [Goal]()
        let fetchRequest = NSFetchRequest<Goal>(entityName: "Goal")
        do {
            results = try DataSource.shared.backgroundContext.fetch(fetchRequest)
        } catch {
            print(error)
        }
        
        return results
    }
    
    func goalsListForRead(success: ([Goal])->Void) {
        
        var results = [Goal]()
        let fetchRequest = NSFetchRequest<Goal>(entityName: "Goal")
        do {
            results = try DataSource.shared.viewContext.fetch(fetchRequest)
            success(results)
        } catch {
            print(error)
        }
    }
    
    func searchGoal(goalID: String, success: (Goal?)->Void) {
        
        var results : Goal?
        let fetchRequest = NSFetchRequest<Goal>(entityName: "Goal")
        fetchRequest.predicate = NSPredicate(format: "id == %@", goalID)
        do {
            results = try DataSource.shared.backgroundContext.fetch(fetchRequest).first
        } catch {
            print(error)
        }
        
        success(results)
    }
}
