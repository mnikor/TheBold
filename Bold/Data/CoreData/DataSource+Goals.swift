//
//  DataSource+Goals.swift
//  Bold
//
//  Created by Alexander Kovalov on 9/3/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import CoreData

protocol GoalsFunctionality {
    func createNewGoal() -> Goal
    func updateGoal()
    func deleteGoal(goalID: String, success: @escaping VoidCallback)
    func goalsListForUpdate() -> [Goal]
}

extension DataSource: GoalsFunctionality {
    
    func createNewGoal() -> Goal {
        let newGoal = Goal()
        newGoal.id = newGoal.objectID.uriRepresentation().lastPathComponent
        newGoal.startDate = Date() as NSDate
        newGoal.endDate = Date() as NSDate
        newGoal.color = ColorGoalType.orange.rawValue
        newGoal.icon = IdeasType.marathon.rawValue
        newGoal.status = StatusType.wait.rawValue
        return newGoal
    }
    
    func updateGoal() {
        
    }
    
    func doneGoal(goalID: String, success: ()->Void) {
        
        var results : Goal?
        let fetchRequest = NSFetchRequest<Goal>(entityName: "Goal")
        fetchRequest.predicate = NSPredicate(format: "id == %@", goalID)
        do {
            results = try DataSource.shared.backgroundContext.fetch(fetchRequest).first
        } catch {
            print(error)
        }
        
        if let result = results {
            result.status = StatusType.completed.rawValue
            DataSource.shared.saveBackgroundContext()
//            NotificationService.shared.createStandardNotification(.goalAchieved)
            AlertViewService.shared.input(.congratulationsGoal(points: PointsForAction.congratulationsGoal, tapGet: {
                LevelOfMasteryService.shared.input(.addPoints(points: PointsForAction.congratulationsGoal))
            }))
            // TODO: Что мы должны делать с Action после получения Achieved
//            checkAllEventOfAction(actionID: result.action!.id!)
        }
        success()
    }
    
    //удаляем Цель
    func deleteGoal(goalID: String, success: @escaping VoidCallback) {
        self.searchGoal(goalID: goalID) { (result) in
            guard let goal = result else { return }
            self.searchEventsReminderOfGoal(goalID: goalID) {
                DataSource.shared.backgroundContext.delete(goal)
                DataSource.shared.saveBackgroundContext()
            }
            success()
        }
    }
    
    func goalsListForUpdate() -> [Goal] {
        
        var results = [Goal]()
        let fetchRequest = NSFetchRequest<Goal>(entityName: "Goal")
        let sort = NSSortDescriptor(key: "name", ascending: false)
        fetchRequest.predicate = NSPredicate(format: "status < %d", StatusType.completed.rawValue)
        fetchRequest.sortDescriptors = [sort]
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
        
        let filterDate = Date().dayOfMonthOfYear() as NSDate
        
//        fetchRequest.predicate = NSPredicate(format: "(endDate >= %@) AND ((status = %d) OR (status = %d))", filterDate, StatusType.wait.rawValue, StatusType.locked.rawValue)
        
        do {
            results = try DataSource.shared.viewContext.fetch(fetchRequest)
            
            for result in results {
                print("\(result.name) status: \(result.status)")
            }
            
            success(results)
        } catch {
            success([])
            print(error)
        }
    }
    
    func goalsEndDateForAll() -> Date? {
        
        var results = [Goal]()
        let fetchRequest = NSFetchRequest<Goal>(entityName: "Goal")
        let sort = NSSortDescriptor(key: "endDate", ascending: false)
        let endDate = Date().dayOfMonthOfYear() as NSDate
        
        fetchRequest.sortDescriptors = [sort]
        fetchRequest.predicate = NSPredicate(format: "(endDate >= %@) AND ((status = %d) OR (status = %d))", endDate, StatusType.wait.rawValue, StatusType.locked.rawValue)
        
        do {
            results = try DataSource.shared.viewContext.fetch(fetchRequest)
        } catch {
            print(error)
        }
        
        guard let goal = results.first else { return nil }
        return goal.endDate as Date?
    }
    
    func goalsStartDateForArchieve() -> Date? {
        
        var results = [Goal]()
        let fetchRequest = NSFetchRequest<Goal>(entityName: "Goal")
        let sort = NSSortDescriptor(key: "startDate", ascending: true)
        let startDate = Date().beforeTheDay().dayOfMonthOfYear() as NSDate
        
        fetchRequest.sortDescriptors = [sort]
        fetchRequest.predicate = NSPredicate(format: "(startDate <= %@)", startDate, StatusType.completed.rawValue) //, StatusType.failed.rawValue)
        
        do {
            results = try DataSource.shared.viewContext.fetch(fetchRequest)
            
        } catch {
            print(error)
        }
        
        guard let goal = results.first else { return nil }
        return goal.startDate as Date?
    }
    
    func goalsListForArchieved(success: ([Goal])->Void) {
        
        var results = [Goal]()
        let fetchRequest = NSFetchRequest<Goal>(entityName: "Goal")
        
        let filterDate = Date().dayOfMonthOfYear() as NSDate
        
        fetchRequest.predicate = NSPredicate(format: "(endDate >= %@) AND ((status = %d) OR (status = %d))", filterDate, StatusType.completed.rawValue) //, StatusType.failed.rawValue)
        
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
    
    func listLevelOfMasteryGoal() -> [Goal] {
        
        var results = [Goal]()
        let fetchRequest = NSFetchRequest<Goal>(entityName: "Goal")
        fetchRequest.predicate = NSPredicate(format: "status = %d", StatusType.completed.rawValue)
        
        do {
            results = try DataSource.shared.viewContext.fetch(fetchRequest)
        } catch {
            print(error)
        }
        
        return results
    }
    
    func searchOverdueGoals() -> [Goal] {
        
        var results = [Goal]()
        let filterDate = Date().dayOfMonthOfYear() as NSDate
        
        let fetchRequest = NSFetchRequest<Goal>(entityName: "Goal")
        let sort = NSSortDescriptor(key: "startDate", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        fetchRequest.predicate = NSPredicate(format: "endDate < %@ AND status < %d", filterDate, StatusType.completed.rawValue)
        
        do {
            results = try DataSource.shared.viewContext.fetch(fetchRequest)
        } catch {
            print(error)
        }
        
        return results
    }
}
