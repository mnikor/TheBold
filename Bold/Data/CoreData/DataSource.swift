//
//  DataSource.swift
//  Bold
//
//  Created by Alexander Kovalov on 9/3/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import CoreData

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
    
    private var updateDataSource : (()->Void)?
    
    var viewContext: NSManagedObjectContext
    let persistentContainer: NSPersistentContainer
    let backgroundContext: NSManagedObjectContext
    
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
    
    func ifUpdateContext(update: @escaping ()->Void) {
        updateDataSource = update
    }
    
    func addedNotification() {
        let notificationCenter = NotificationCenter.default
//        notificationCenter.addObserver(self, selector: #selector(managedObjectContextObjectsDidChange), name: NSNotification.Name.NSManagedObjectContextObjectsDidChange, object: backgroundContext)
//        notificationCenter.addObserver(self, selector: #selector(managedObjectContextWillSave), name: NSManagedObjectContextWillSaveNotification, object: managedObjectContext)
        notificationCenter.addObserver(self, selector: #selector(managedObjectContextDidSave), name: NSNotification.Name.NSManagedObjectContextDidSave, object: backgroundContext)
    }
    
//    private @objc func managedObjectContextObjectsDidChange() {
//        updateDataSource?()
//    }
    
    @objc private func managedObjectContextDidSave() {
        updateDataSource?()
    }
    
    func saveBackgroundContext() {
        guard backgroundContext.hasChanges else {
            return
        }
        do {
            try backgroundContext.save()
            //updateDataSource?()
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
    
    func entityForName(name: DataTablesType) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: name.rawValue, in: DataSource.shared.backgroundContext)
    }
}
