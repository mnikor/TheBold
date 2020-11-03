//
//  Content+CoreDataClass.swift
//  
//
//  Created by Alexander Kovalov on 9/4/19.
//
//

import Foundation
import CoreData


public class Content: NSManagedObject {

    convenience init() {
        
        let entity = DataSource.shared.entityForName(name: .content)
        self.init(entity: entity!, insertInto: DataSource.shared.backgroundContext)
    }
    
    func searchContent() {
        
    }
    
    func map(activityContent: ActivityContent) {
        authorName = activityContent.authorName
        authorPhotoUrl = activityContent.authorPhotoURL
        body = activityContent.body
        footer = activityContent.footer
        id = Int32(activityContent.id)
        imageUrl = activityContent.imageURL
        isLock = activityContent.contentStatus == .locked
        largeImage = activityContent.largeImageURL
        likesCount = Int16(activityContent.likesCount)
        pointsUnlock = Int16(activityContent.pointOfUnlock)
        smallImage = activityContent.smallImageURL
        title = activityContent.title
        type = activityContent.type.rawValue
        durationRead = Int16(activityContent.durtionRead)
        animationKey = activityContent.animationKey
        
        File.fill(audioTracks: activityContent.audioTracks,
                  to: self)
        if let documentURL = activityContent.documentURL {
            let pdfFile = File()
            pdfFile.map(pdfFile: documentURL)
            addToFiles(pdfFile)
        }
    }
    
    func setHidden( _ isHidden: Bool) {
        self.isHidden = isHidden
    }
    
}
