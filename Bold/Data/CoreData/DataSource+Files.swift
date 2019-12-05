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
                    let file = self.fetchFile(with: result.url)
                    else { return }
                file.path = result.path
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
    
}
