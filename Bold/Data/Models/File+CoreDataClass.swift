//
//  File+CoreDataClass.swift
//  
//
//  Created by Alexander Kovalov on 9/3/19.
//
//

import Foundation
import CoreData


public class File: NSManagedObject {

    convenience init() {
        
        let entity = DataSource.shared.entityForName(name: .file)
        self.init(entity: entity!, insertInto: DataSource.shared.backgroundContext)
    }
    
    static func fill(audioTracks: [AudioPlayerTrackInfo],
              to content: Content) {
        for audioTrack in audioTracks {
            let fileMO = File()
            fileMO.map(audioTrack: audioTrack)
            content.addToFiles(fileMO)
        }
    }
    
    func map(pdfFile: FilePath) {
        isAudio = false
        switch pdfFile {
        case .local(let filePath):
            name = URL(fileURLWithPath: filePath).lastPathComponent
            path = filePath
        case .remote(let urlString):
            name = URL(string: urlString)?.lastPathComponent
            url = urlString
        }
        isDownloaded = path != nil
    }
    
    func map(audioTrack: AudioPlayerTrackInfo) {
        isAudio = true
        isDownloaded = true
        name = audioTrack.trackName
        switch audioTrack.path {
        case .local(let path):
            self.path = path
        case .remote(let url):
            self.url = url
        }
    }
    
}
