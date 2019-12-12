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
    func saveContent(content: ActivityContent)
    func deleteContent(content: ActivityContent)
    func contains(content: ActivityContent) -> Bool
}

extension DataSource: ContentFunctionality {
    private func fetchOrCreateContent(activityContent: ActivityContent) -> Content {
        guard let content = fetchContent(activityContent: activityContent)
            else {
                return Content()
        }
        return content
    }
    
    func fetchContent(activityContent: ActivityContent) -> Content? {
        let fetchRequest: NSFetchRequest<Content> = Content.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", Int32(activityContent.id))
        return (try? DataSource.shared.backgroundContext.fetch(fetchRequest))?.first
    }
    
    func saveContent(content: ActivityContent) {
        persistentContainer.performBackgroundTask { [unowned self] context in
            do {
                let contentMO = self.fetchOrCreateContent(activityContent: content)
                contentMO.map(activityContent: content)
                try self.backgroundContext.save()
                self.loadFiles(content: content)
            } catch {
                // TODO: - error handling
            }
        }
    }
    
    func deleteContent(content: ActivityContent) {
        persistentContainer.performBackgroundTask { [unowned self] context in
            do {
                if let contentMO = self.fetchContent(activityContent: content) {
                    self.backgroundContext.delete(contentMO)
                }
                try self.backgroundContext.save()
            } catch {
                // TODO: - error handling
            }
        }
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
    
    func contains(content: ActivityContent) -> Bool {
        return fetchContent(activityContent: content) != nil
    }
    
    func contentList() -> [Content] {
        let fetchRequest: NSFetchRequest<Content> = Content.fetchRequest()
        return (try? backgroundContext.fetch(fetchRequest)) ?? []
    }
    
    private func loadFiles(content: ActivityContent) {
        var filePaths: [FilePath] = []
        if let documentURL = content.documentURL {
            filePaths.append(documentURL)
        }
        filePaths += content.audioTracks.compactMap { $0.path }
        loadFiles(filePaths: filePaths)
    }
    
}
