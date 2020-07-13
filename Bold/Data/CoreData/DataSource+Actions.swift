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
    
    @discardableResult
    func createNewAction(goalID: String?, contentID: String?) -> Action {
        let newAction = Action()
        newAction.id = newAction.objectID.uriRepresentation().lastPathComponent
        newAction.startDateType = ActionDateType.today.rawValue
        newAction.endDateType = ActionDateType.tommorow.rawValue
        newAction.startDate = Date().baseTime() as NSDate
        newAction.endDate = Date().tommorowDay() as NSDate
        newAction.repeatAction = DaysOfWeek()
        let reminderMe = Reminder()
        reminderMe.isSetTime = false
        reminderMe.type = RemindMeType.noReminders.rawValue
        //reminderMe.timeInterval = 12 * 3600
        newAction.reminderMe = reminderMe
        newAction.stake = 0
        newAction.status = StatusType.create.rawValue
        
        if let goalIDTemp = goalID {
            DataSource.shared.searchGoal(goalID: goalIDTemp) { (goal) in
                newAction.goal = goal
                
                let endDateAction = newAction.endDate! as Date
                let endDate : Date? = newAction.goal?.endDate as Date?
                if let endDateTemp = endDate, endDateTemp < endDateAction {
                    newAction.endDate = endDateTemp as NSDate
                }
            }
        }
        
        if let contentIDTemp = contentID {
            DataSource.shared.searchContent(contentID: contentIDTemp) { (content) in
                newAction.name = content?.type?.capitalized
                newAction.content = content
            }
        }

        return newAction
    }
    
    //Удаляем Экшен и нотификации которые могут к нему относится, проверяем Гол
    func deleteAction(actionID: String, success: @escaping ()->Void) {
        
        searchAction(actionID: actionID) { (result) in
            guard let action = result else { return }
            let goalID = action.id
            DataSource.shared.searchEventsReminderOfAction(actionID: actionID) { [weak self] in
                DataSource.shared.backgroundContext.delete(action)
                DataSource.shared.saveBackgroundContext()
                self?.checkAllActionOfGoal(goalID: goalID!)
                success()
            }
        }
    }
    
    func checkAllActionOfGoal(goalID: String?) {
        
        guard let goalID = goalID else { return }
        
        var results : [Action]!
        let fetchRequest = NSFetchRequest<Action>(entityName: "Action")
        fetchRequest.predicate = NSPredicate(format: "((status = %d) OR (status = %d)) AND SUBQUERY(goal, $gl, $gl.id == '\(goalID)').@count > 0", StatusType.completed.rawValue) //, StatusType.failed.rawValue)
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
//                NotificationService.shared.createStandardNotification(.goalAchieved)
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
