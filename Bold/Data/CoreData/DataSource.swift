//
//  DataSource.swift
//  Bold
//
//  Created by Alexander Kovalov on 9/3/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import CoreData
import RxSwift
import RxCocoa
import Foundation

enum DataTablesType: String {
    case content = "Content"
    case file = "File"
    case goal = "Goal"
    case action = "Action"
    case event = "Event"
    case user = "User"
    case daysOfWeek = "DaysOfWeek"
    case reminder = "Reminder"
}

struct DataConstants {
    static let coreDataModel = "Bold"
}

class DataSource {
    
    static let shared = DataSource()
    
    var viewContext: NSManagedObjectContext
    let persistentContainer: NSPersistentContainer
    let backgroundContext: NSManagedObjectContext
    
    private let changeContextVariable : BehaviorRelay<String> = BehaviorRelay(value: "Update")
    var changeContext : Observable<String> {
        return changeContextVariable.asObservable()
    }
    
    private let changePremiumVariable : BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var changePremium : Observable<Bool> {
        return changePremiumVariable.asObservable()
    }
    
    private init() {
        let container = NSPersistentContainer(name: DataConstants.coreDataModel)
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        persistentContainer = container
        viewContext = container.viewContext
        viewContext.automaticallyMergesChangesFromParent = true
        backgroundContext = container.newBackgroundContext()
        backgroundContext.automaticallyMergesChangesFromParent = true
        
        addedNotification()
    }
    
    func addedNotification() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(managedObjectContextObjectsDidChange), name: NSNotification.Name.NSManagedObjectContextObjectsDidChange, object: viewContext)
        notificationCenter.addObserver(self, selector: #selector(contextObjectsDidChange(_:)), name: NSNotification.Name.NSManagedObjectContextObjectsDidChange, object: backgroundContext)
//        notificationCenter.addObserver(self, selector: #selector(managedObjectContextWillSave), name: NSManagedObjectContextWillSaveNotification, object: managedObjectContext)
//        notificationCenter.addObserver(self, selector: #selector(managedObjectContextDidSave), name: NSNotification.Name.NSManagedObjectContextDidSave, object: backgroundContext)
    }
    
    @objc private func managedObjectContextObjectsDidChange() {
        changeContextVariable.accept("ContextDidSave")
        print("ViewContextDidSave")
    }
    
    @objc private func contextObjectsDidChange(_ notification: Notification) {
        
        guard let userInfo = notification.userInfo else {
            return
        }
        
        if let updates = userInfo[NSUpdatedObjectsKey] as? Set<NSManagedObject> {
            for update in updates {
                if let user = update as? User {
                    let valueDict = user.changedValues()
                    if let status : Bool = valueDict["premiumOn"] as? Bool, status == true {
                        print("++++++++ChangePremium to ON and send subscription")
//                        let isPremium = NSNumber(value: status)
                        changePremiumVariable.accept(status)
                    }
                }
            }
        }
    }
    
    func saveBackgroundContext() {
        guard backgroundContext.hasChanges else {
            return
        }
        do {
            try backgroundContext.save()
        } catch {
            let error = error as NSError
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }
    }
    
    func deleteAll(of entityName: String, context: NSManagedObjectContext) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(deleteRequest)
        } catch {
            let error = error as NSError
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }
    }
    
    func resetBackgroundContext() {
        guard backgroundContext.hasChanges else {
            return
        }
        backgroundContext.reset()
    }
    
    func entityForName(name: DataTablesType) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: name.rawValue, in: DataSource.shared.backgroundContext)
    }
}
