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
    func updateAction(actionID: String, success: (Action?)->Void)
    func deleteAction(actionID: String, success: ()->Void)
}

extension DataSource: ActionsFunctionality {
    
    func createAction() {
        
    }
    
    func deleteAction(actionID: String, success: ()->Void) {
        
        updateAction(actionID: actionID) { (result) in
            guard let action = result else { return }
            DataSource.shared.backgroundContext.delete(action)
            DataSource.shared.saveBackgroundContext()
            success()
        }
    }
    
    func updateAction(actionID: String, success: (Action?)->Void) {
        
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
}
