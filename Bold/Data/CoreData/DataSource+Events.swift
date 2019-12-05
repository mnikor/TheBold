//
//  DataSource+Events.swift
//  Bold
//
//  Created by Alexander Kovalov on 9/24/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation
import CoreData

protocol EventFunctionality {
    func createEvent()
    func updateEvent()
    func deleteEvent()
}

extension DataSource: EventFunctionality {
    func createEvent() {
        
    }
    
    func updateEvent() {
        
    }
    
    func deleteEvent() {
        
    }
    
    func doneEvent(eventID: String, success: ()->Void) {
        
        var results : Event?
        let fetchRequest = NSFetchRequest<Event>(entityName: "Event")
        fetchRequest.predicate = NSPredicate(format: "id == %@", eventID)
        do {
            results = try DataSource.shared.backgroundContext.fetch(fetchRequest).first
        } catch {
            print(error)
        }
        
        if let result = results {
            result.status = StatusType.completed.rawValue
            DataSource.shared.saveBackgroundContext()
            NotificationService.shared.createStandardNotification( result.stake != 0 ? .actionCompleteWithStake : .actionCompleteWithoutStake)
            AlertViewService.shared.input(.congratulationsAction(points: result.calculatePoints, tapGet: {
                LevelOfMasteryService.shared.input(.addPoints(points: PointsForAction.congratulationsAction))
            }))
            checkAllEventOfAction(actionID: result.action!.id!)
        }
        success()
    }
    
    func checkAllEventOfAction(actionID: String) {
        
        var results : [Event]!
        let fetchRequest = NSFetchRequest<Event>(entityName: "Event")
        fetchRequest.predicate = NSPredicate(format: "((status = %d) OR (status = %d)) AND SUBQUERY(action, $act, $act.id == '\(actionID)').@count > 0", StatusType.completed.rawValue, StatusType.failed.rawValue)
        do {
            results = try DataSource.shared.backgroundContext.fetch(fetchRequest)
        } catch {
            print(error)
        }
        
        if results.isEmpty {
            return
        }
        
        DataSource.shared.searchAction(actionID: actionID) { (action) in
            if action?.events?.count == results.count {
                action?.status = StatusType.completed.rawValue
                DataSource.shared.saveBackgroundContext()
            }
            checkAllActionOfGoal(goalID: action!.id!)
        }
    }
    
    func searchEventsInGoal(goalID: String?, startDate:Date, endDate:Date, success:([Event])->Void) {
        
        var results = [Event]()
        let fetchRequest = NSFetchRequest<Event>(entityName: "Event")
        let sort = NSSortDescriptor(key: "startDate", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        let start = startDate as NSDate
        let end = endDate as NSDate
        
        if let goalIDString = goalID {
            fetchRequest.predicate = NSPredicate(format: "(startDate >= %@) AND (startDate <= %@) AND SUBQUERY(action, $act, $act.goal.id == '\(goalIDString)').@count > 0", start, end)
        }else {
            fetchRequest.predicate = NSPredicate(format: "(startDate >= %@) AND (startDate <= %@)", start, end)
        }
        
        do {
            results = try DataSource.shared.viewContext.fetch(fetchRequest)
            success(results)
        } catch {
            print(error)
        }
    }
    
    func searchEventsInGoals(startDate:Date, offset: Int, success:([Event])->Void) {
        
        var results = [Event]()
        let fetchRequest = NSFetchRequest<Event>(entityName: "Event")
        let sort = NSSortDescriptor(key: "startDate", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        let start = startDate as NSDate
        let nextDay = startDate.tommorowDay() as NSDate
        
        fetchRequest.fetchOffset = offset
        fetchRequest.fetchLimit = 30
        
        fetchRequest.predicate = NSPredicate(format: "((startDate > %@) AND (startDate < %@) AND (status >= %d)) OR ((startDate => %@) AND (status = %d))", start, nextDay, StatusType.wait.rawValue, nextDay, StatusType.wait.rawValue)
        
        do {
            results = try DataSource.shared.viewContext.fetch(fetchRequest)
            success(results)
        } catch {
            print(error)
        }
    }
    
    func searchAllEventsInGoal(goalID: String) -> [Event] {
        
        var results = [Event]()
        let fetchRequest = NSFetchRequest<Event>(entityName: "Event")
        let sort = NSSortDescriptor(key: "startDate", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        
        let startDate = Date().customTime(hour: 0, minute: 0)
        let calendar = Calendar.current
        let components = calendar.dateComponents([.month, .year], from: startDate)
        let firstDayMonthDate = calendar.date(from: components)!
        
        fetchRequest.predicate = NSPredicate(format: " (startDate >= %@) AND (status == \(StatusType.wait.rawValue) OR status == \(StatusType.failed.rawValue) OR status == \(StatusType.completed.rawValue)) AND SUBQUERY(action, $act, $act.goal.id == '\(goalID)').@count > 0", firstDayMonthDate as NSDate)
        
        do {
            results = try DataSource.shared.viewContext.fetch(fetchRequest)
        } catch {
            print(error)
        }
        
        return results
    }
    
    func searchEventsInGoal(goalID: String) -> NSFetchedResultsController<Event> {
        
        let fetchRequest = NSFetchRequest<Event>(entityName: "Event")
        let sort = NSSortDescriptor(key: "startDate", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        
        fetchRequest.predicate = NSPredicate(format: "SUBQUERY(action, $act, $act.goal.id == '\(goalID)').@count > 0")
        
        return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: DataSource.shared.viewContext, sectionNameKeyPath: nil, cacheName: nil)
    }
    
    func listDeleteEvent(actionID: String, deleteDate: Date, success:()->Void) {
        
        var results = [Event]()
        let fetchRequest = NSFetchRequest<Event>(entityName: "Event")
        let sort = NSSortDescriptor(key: "startDate", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        let currentDate = deleteDate as NSDate
        
        fetchRequest.predicate = NSPredicate(format: "(startDate > %@) AND SUBQUERY(action, $act, $act.id == '\(actionID)').@count > 0", currentDate)
        
        do {
            results = try DataSource.shared.backgroundContext.fetch(fetchRequest)
            for event in results {
                DataSource.shared.backgroundContext.delete(event)
            }
            success()
        } catch {
            print(error)
        }
        
    }
    
    func searchOverdueEvents() -> [Event] {
        
        var results = [Event]()
        let filterDate = Date().dayOfMonthOfYear() as NSDate
        
        let fetchRequest = NSFetchRequest<Event>(entityName: "Event")
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
}
