//
//  DataSource+Contents.swift
//  Bold
//
//  Created by Alexander Kovalov on 9/3/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation
import CoreData

protocol ContentFunctionality {
    func addContent()
    func updateContent()
    func deleteContent()
}

extension DataSource: ContentFunctionality {
    func addContent() {
        
    }
    
    func updateContent() {
        
    }
    
    func deleteContent() {
        
    }
    
    func searchContent(contentID: String, success: (Content?)->Void) {
        
        var results : Content?
        let fetchRequest = NSFetchRequest<Content>(entityName: "Content")
        fetchRequest.predicate = NSPredicate(format: "id == %@", contentID)
        do {
            results = try DataSource.shared.backgroundContext.fetch(fetchRequest).first
        } catch {
            print(error)
        }
        
        success(results)
    }
}
