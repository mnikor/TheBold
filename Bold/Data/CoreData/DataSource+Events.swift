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
}
