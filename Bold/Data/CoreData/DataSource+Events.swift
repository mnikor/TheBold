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
    
    func searchEventsInGoal(goalID: String, startDate:Date, endDate:Date, success:([Event])->Void) {
        
        var results = [Event]()
        let fetchRequest = NSFetchRequest<Event>(entityName: "Event")
        let sort = NSSortDescriptor(key: "startDate", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        
//        let startDate = Date().customTime(hour: 0, minute: 0)
//        
//            let calendar = Calendar.current
//            let components = calendar.dateComponents([.month, .year], from: startDate)
//        let firstDayMonthDate = calendar.date(from: components)!
//            let endDate = Calendar.current.date(byAdding: .month, value: 1, to: firstDayMonthDate)!
//        
        let start = startDate as NSDate
        let end = endDate as NSDate
        
        fetchRequest.predicate = NSPredicate(format: "(startDate >= %@) AND (startDate <= %@) AND SUBQUERY(action, $act, $act.goal.id == '\(goalID)').@count > 0", start, end)
        
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
