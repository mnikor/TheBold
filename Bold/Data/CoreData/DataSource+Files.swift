//
//  DataSource+Files.swift
//  Bold
//
//  Created by Admin on 25.11.2019.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation
import CoreData

protocol FileFunctionality {
    func loadFile(with filePath: FilePath?)
    func loadFiles(filePaths: [FilePath])
}

extension DataSource: FileFunctionality {
    
    func loadFile(with filePath: FilePath?) {
        switch filePath {
        case .local, nil:
            break
        case .remote(let urlString):
            NetworkService.shared.loadFile(with: urlString) { [unowned self] result in
                guard let result = result,
                      let file = self.fetchFile(with: result.url.absoluteString)
                    else { return }
                file.path = result.path.absoluteString
            }
        }
    }
    
    func loadFiles(filePaths: [FilePath]) {
        for filePath in filePaths {
            loadFile(with: filePath)
        }
    }
    
    func fetchFile(with url: String) -> File? {
        let fetchRequest: NSFetchRequest<File> = File.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "url == %@", url)
        return (try? DataSource.shared.backgroundContext.fetch(fetchRequest).first)
    }
    
    func createNewFiles(forAnimation animation: AnimateContent) -> (animate: File?, image: File?) {
        
        let type : FileType!
        var fileImage : File! = nil
        
        guard let fileURL = animation.fileURL else { return (nil, nil) }
        
        if fileURL.contains(".json") {
            type = FileType.anim_json
        }else {
            type = FileType.anim_video
        }
        
        let fileAnimate = File()
        fileAnimate.type = type.rawValue
        fileAnimate.isDownloaded = false
        fileAnimate.name = animation.title
        fileAnimate.url = animation.fileURL
        fileAnimate.key = animation.key
        fileAnimate.updatedAt = DateFormatter.formatting(type: .contentUpdateAt, dateString: animation.updatedAt)
        
        if let imageURL = animation.imageURL {
            
            fileImage = File()
            fileImage.type = FileType.anim_image.rawValue
            fileImage.isDownloaded = false
            fileImage.name = animation.title
            fileImage.url = imageURL
            fileImage.key = animation.key
            fileImage.updatedAt = DateFormatter.formatting(type: .contentUpdateAt, dateString: animation.updatedAt)
        }
        
        DataSource.shared.saveBackgroundContext()
        
        return (fileAnimate, fileImage)
    }
    
    func searchAnimationFiles() -> [File] {
        
        var results = [File]()
        let fetchRequest = NSFetchRequest<File>(entityName: "File")
        let sort = NSSortDescriptor(key: "updatedAt", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        fetchRequest.predicate = NSPredicate(format: "type == %d OR type == %d OR type == %d", FileType.anim_video.rawValue, FileType.anim_image.rawValue, FileType.anim_json.rawValue)
        
        do {
            results = try DataSource.shared.backgroundContext.fetch(fetchRequest)
        } catch {
            print(error)
        }

//        _ = results.map{    DataSource.shared.backgroundContext.delete($0)}
//        DataSource.shared.saveBackgroundContext()
        
        return results
    }
    
    func searchFile(forKey key: String, type: FileType) -> File? {
        
        var results = [File]()
        let fetchRequest = NSFetchRequest<File>(entityName: "File")
        fetchRequest.predicate = NSPredicate(format: "key == %@ AND type == %d", key, type.rawValue)
        
        do {
            results = try DataSource.shared.viewContext.fetch(fetchRequest)
        } catch {
            print(error)
        }
        
        return results.first
    }
    
    func searchFile(forURL url: String) -> File? {
        
        var results = [File]()
        let fetchRequest = NSFetchRequest<File>(entityName: "File")
        fetchRequest.predicate = NSPredicate(format: "url == %@", url)
        
        do {
            results = try DataSource.shared.backgroundContext.fetch(fetchRequest)
        } catch {
            print(error)
        }
        
        return results.first
    }
    
}
