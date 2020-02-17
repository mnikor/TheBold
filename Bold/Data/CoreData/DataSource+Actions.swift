//
//  DataSource+Actions.swift
//  Bold
//
//  Created by Alexander Kovalov on 9/3/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation
import CoreData

protocol ActionsFunctionality {
    func createAction()
    func searchAction(actionID: String, success: (Action?)->Void)
    func deleteAction(actionID: String, success: @escaping ()->Void)
}

extension DataSource: ActionsFunctionality {
    
    func createAction() {
        
    }
    
    func deleteAction(actionID: String, success: @escaping ()->Void) {
        
        searchAction(actionID: actionID) { (result) in
            guard let action = result else { return }
            let goalID = action.goal?.id
            NotificationService.shared.createStandardNotification(.actionDeleted(completion: { [weak self] confirmationResult in
                if confirmationResult {
                    DataSource.shared.backgroundContext.delete(action)
                    DataSource.shared.saveBackgroundContext()
                    self?.checkAllActionOfGoal(goalID: goalID)
                    success()
                }
            }))
        }
    }
    
    func checkAllActionOfGoal(goalID: String?) {
        
        guard let goalID = goalID else { return }
        
        var results : [Action]!
        let fetchRequest = NSFetchRequest<Action>(entityName: "Action")
        fetchRequest.predicate = NSPredicate(format: "((status = %d) OR (status = %d)) AND SUBQUERY(goal, $gl, $gl.id == '\(goalID)').@count > 0", StatusType.completed.rawValue, StatusType.failed.rawValue)
        do {
            results = try DataSource.shared.backgroundContext.fetch(fetchRequest)
        } catch {
            print(error)
        }
        
        if results.isEmpty {
            return
        }
        
        DataSource.shared.searchGoal(goalID: goalID) { (goal) in
            if goal?.actions?.count == results.count {
                goal?.status = StatusType.completed.rawValue
                DataSource.shared.saveBackgroundContext()
                NotificationService.shared.createStandardNotification(.goalAchieved)
                AlertViewService.shared.input(.congratulationsGoal(points: PointsForAction.congratulationsGoal, tapGet: {
                    LevelOfMasteryService.shared.input(.addPoints(points: PointsForAction.congratulationsGoal))
                }))
            }
        }
    }
    
    func searchAction(actionID: String, success: (Action?)->Void) {
        
        var results : Action?
        let fetchRequest = NSFetchRequest<Action>(entityName: "Action")
        fetchRequest.predicate = NSPredicate(format: "id == %@", actionID)
        do {
            results = try DataSource.shared.backgroundContext.fetch(fetchRequest).first
        } catch {
            print(error)
        }
        
        success(results)
    }
    
    func searchOverdueActions() -> [Action] {
        
        var results = [Action]()
        let filterDate = Date().dayOfMonthOfYear() as NSDate
        
        let fetchRequest = NSFetchRequest<Action>(entityName: "Action")
        let sort = NSSortDescriptor(key: "startDate", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        fetchRequest.predicate = NSPredicate(format: "endDate < %@ AND status < %d", filterDate, StatusType.completed.rawValue)
        
        do {
            results = try DataSource.shared.backgroundContext.fetch(fetchRequest)
        } catch {
            print(error)
        }
        
        return results
    }
    
    
    func checkActionStatus(actionID: String) {
        
        
        
    }
}
