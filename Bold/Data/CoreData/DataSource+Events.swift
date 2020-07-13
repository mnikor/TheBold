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
    
    func createEvent(action: Action, startDate: Date, endDate: Date, reminderDate: Date?) {
        
        let event = Event()
        event.id = event.objectID.uriRepresentation().lastPathComponent
        event.name = action.name
        event.startDate = startDate as NSDate
        event.endDate = endDate as NSDate
        event.reminderDate = reminderDate as NSDate?
        event.stake = action.stake
        event.status = StatusType.wait.rawValue
        event.action = action
        
        if let reminderDate = reminderDate, let remind = action.reminderMe, let type = RemindMeType(rawValue: remind.type) {
            NotificationService.shared.input(.createRemider(actionTitle: event.name!, stake: Int(event.stake), date: reminderDate, reminderType: type, identifier: event.id!, startDate: startDate, endDate: endDate))
            
        }
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
            
            if let _ = result.reminderDate {
                NotificationService.shared.input(.removeReimder(identifiers: [eventID]))
            }
            
            AlertViewService.shared.input(.congratulationsAction(points: result.calculatePoints, tapGet: {
                LevelOfMasteryService.shared.input(.addPoints(points: result.calculatePoints))
            }))
            checkAllEventOfAction(actionID: result.action!.id!)
        }
        success()
    }
    
    func checkAllEventOfAction(actionID: String) {
        
        var results : [Event]!
        let fetchRequest = NSFetchRequest<Event>(entityName: "Event")
        fetchRequest.predicate = NSPredicate(format: "((status = %d) OR (status = %d)) AND SUBQUERY(action, $act, $act.id == '\(actionID)').@count > 0", StatusType.completed.rawValue)//, StatusType.failed.rawValue)
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
        let nextDay = startDate.tommorowDay() as NSDate
        let end = endDate as NSDate
        
        if let goalIDString = goalID {
            fetchRequest.predicate = NSPredicate(format: "(((startDate => %@) AND (startDate < %@)) OR ((startDate => %@) AND (startDate < %@) AND (status = %d))) AND SUBQUERY(action, $act, $act.goal.id == '\(goalIDString)').@count > 0", start, nextDay, nextDay, end, StatusType.wait.rawValue)
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
    
    func searchEventsInAllGoals(firstRequest:Bool, startDate:Date, endDate:Date, success:([Event])->Void) {

        var results = [Event]()
        let fetchRequest = NSFetchRequest<Event>(entityName: "Event")
        let sort = NSSortDescriptor(key: "startDate", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        let start = startDate as NSDate
        let nextDay = startDate.tommorowDay() as NSDate
        let end = endDate as NSDate

        if firstRequest {
            fetchRequest.predicate = NSPredicate(format: "((startDate => %@) AND (startDate < %@)) OR ((startDate => %@) AND (startDate < %@) AND (status = %d))", start, nextDay, nextDay, end, StatusType.wait.rawValue)
        }else {
            fetchRequest.predicate = NSPredicate(format: "((startDate => %@) AND (startDate < %@) AND (status = %d))", start, end, StatusType.wait.rawValue)
        }
        
        do {
            results = try DataSource.shared.viewContext.fetch(fetchRequest)
            success(results)
        } catch {
            print(error)
        }
    }
    
    func searchEventsInAllGoalsArchive(startDate:Date, endDate:Date, success:([Event])->Void) {

        var results = [Event]()
        let fetchRequest = NSFetchRequest<Event>(entityName: "Event")
        let sort = NSSortDescriptor(key: "startDate", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        let start = startDate as NSDate
        let end = endDate as NSDate

        fetchRequest.predicate = NSPredicate(format: "((startDate => %@) AND (startDate < %@) AND ((status = %d) OR (status = %d)))", start, end, StatusType.completed.rawValue) //, StatusType.failed.rawValue)
        
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
        
        fetchRequest.predicate = NSPredicate(format: " (startDate >= %@) AND (status == \(StatusType.wait.rawValue) OR status == \(StatusType.completed.rawValue)) AND SUBQUERY(action, $act, $act.goal.id == '\(goalID)').@count > 0", firstDayMonthDate as NSDate)
        
   /*     fetchRequest.predicate = NSPredicate(format: " (startDate >= %@) AND (status == \(StatusType.wait.rawValue) OR status == \(StatusType.failed.rawValue) OR status == \(StatusType.completed.rawValue)) AND SUBQUERY(action, $act, $act.goal.id == '\(goalID)').@count > 0", firstDayMonthDate as NSDate) */
        
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
    
    //Ищем и удаляем ивенты в Экшинах
    func listDeleteEvent(actionID: String, deleteDate: Date, success:()->Void) {
        
        var results = [Event]()
        let fetchRequest = NSFetchRequest<Event>(entityName: "Event")
        let sort = NSSortDescriptor(key: "startDate", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        let currentDate = deleteDate as NSDate
        let status = StatusType.completed.rawValue
        
        fetchRequest.predicate = NSPredicate(format: "(startDate >= %@ AND status < %d) AND SUBQUERY(action, $act, $act.id == '\(actionID)').@count > 0", currentDate, status)
        
        do {
            results = try DataSource.shared.backgroundContext.fetch(fetchRequest)
            
            let eventIDs = results.filter({ $0.reminderDate != nil }).compactMap({ $0.id })
            if !eventIDs.isEmpty {
                NotificationService.shared.input(.removeReimder(identifiers: eventIDs))
            }
            
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
    
    //Ищем ивенты онтосяциейся к цели у которых есть напоминания и удаляем нотификации
    func searchEventsReminderOfGoal(goalID: String, success: VoidCallback) {
        var results = [Event]()
        let fetchRequest = NSFetchRequest<Event>(entityName: "Event")
        
        fetchRequest.predicate = NSPredicate(format: "(reminderDate != nil) AND SUBQUERY(action, $act, $act.goal.id == '\(goalID)').@count > 0")
        
        do {
            results = try DataSource.shared.backgroundContext.fetch(fetchRequest)
            
            let eventIDs = results.compactMap { (event) -> String? in
                return event.id
            }
            NotificationService.shared.input(.removeReimder(identifiers: eventIDs))
            
        } catch {
            print(error)
        }
        success()
    }
    
    //Ищем ивенты онтосяциейся к Экшен у которых есть напоминания и удаляем нотификации
    func searchEventsReminderOfAction(actionID: String, success: VoidCallback) {
        var results = [Event]()
        let fetchRequest = NSFetchRequest<Event>(entityName: "Event")
        
        fetchRequest.predicate = NSPredicate(format: "(reminderDate != nil) AND SUBQUERY(action, $act, $act.id == '\(actionID)').@count > 0")
        
        do {
            results = try DataSource.shared.backgroundContext.fetch(fetchRequest)
            
            let eventIDs = results.compactMap { (event) -> String? in
                return event.id
            }
            NotificationService.shared.input(.removeReimder(identifiers: eventIDs))
            
        } catch {
            print(error)
        }
        success()
    }
    
    func countEvents() {
        
    }
}
