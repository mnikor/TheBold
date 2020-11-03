//
//  Content.swift
//  Bold
//
//  Created by Admin on 21.10.2019.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import SwiftyJSON

class ActivityContent: ActivityBase {
//    var id: Int
    var title: String
//    var type: ContentType
    var body: String
    var authorName: String
    var footer: String
    var durtionRead: Int
    var pointOfUnlock: Int
    var contentStatus: ContentStatus
    var imageURL: String?
    var smallImageURL: String?
    var largeImageURL: String?
    var likesCount: Int
    var authorPhotoURL: String?
    var audioTracks: [AudioPlayerTrackInfo]
    var audioPreviews: [AudioPlayerTrackInfo]
    var documentURL: FilePath?
    var documentPreviewURL: String?
    var forCategoryPresentation: Bool
    var color: String?
    var animationKey: String?
    
    init(id: Int, position: Int, type:ContentType, title: String, body: String, authorName: String, footer: String, durtionRead: Int, pointOfUnlock: Int, contentStatus: ContentStatus, imageURL: String?, smallImageURL: String?, largeImageURL: String?, likesCount: Int, authorPhotoURL: String?, audioTracks: [AudioPlayerTrackInfo], audioPreviews: [AudioPlayerTrackInfo], documentURL: FilePath?, documentPreviewURL: String?, forCategoryPresentation: Bool, color: String?, animationKey: String?) {
        self.title = title
        self.body = body
        self.authorName = authorName
        self.footer = footer
        self.durtionRead = durtionRead
        self.pointOfUnlock = pointOfUnlock
        self.contentStatus = contentStatus
        self.imageURL = imageURL
        self.smallImageURL = smallImageURL
        self.largeImageURL = largeImageURL
        self.likesCount = likesCount
        self.authorPhotoURL = authorPhotoURL
        self.audioTracks = audioTracks
        self.audioPreviews = audioPreviews
        self.documentURL = documentURL
        self.forCategoryPresentation = forCategoryPresentation
        self.audioPreviews = audioPreviews
        self.documentPreviewURL = documentPreviewURL
        self.color = color
        self.animationKey = animationKey
        super.init(id: id, position: position, type: type)
    }
    
    func calculateStatus() {
        if pointOfUnlock != 0 && contentStatus == .unlocked {
            if LevelOfMasteryService.shared.currentPoints() >= pointOfUnlock {
                contentStatus = .unlockedPoints
            }else {
                contentStatus = .lockedPoints
            }
        }else if DataSource.shared.readUser().premiumOn == true {
            contentStatus = .unlockedPremium
        }
    }
    
    static func mapJSON(_ json: JSON) -> ActivityContent? {
        let id = json[ResponseKeys.id].intValue
        let title = json[ResponseKeys.title].stringValue
        var typeString = json[ResponseKeys.type].stringValue
        let body = json[ResponseKeys.body].stringValue
        let authorName = json[ResponseKeys.authorName].stringValue
        let footer = json[ResponseKeys.footer].stringValue
        let pointOfUnlock = json[ResponseKeys.pointOfUnlock].intValue
        let contentStatusString = json[ResponseKeys.contentStatus].stringValue
        var contentStatus = ContentStatus(rawValue: contentStatusString.lowercased()) ?? ContentStatus.unlocked
        
        if pointOfUnlock != 0 && contentStatus == .unlocked {
            if LevelOfMasteryService.shared.currentPoints() >= pointOfUnlock {
                contentStatus = .unlockedPoints
            }else {
                contentStatus = .lockedPoints
            }
        }else if DataSource.shared.readUser().premiumOn == true {
            contentStatus = .unlockedPremium
        }
        
        let likesCount = json[ResponseKeys.likesCount].intValue
            
        if typeString.hasPrefix(ResponseKeys.typePrefix) {
            typeString = String(typeString.dropFirst(ResponseKeys.typePrefix.count))
        }
        
        var type : ContentType = .meditation
        
        if let checkType = ContentType(rawValue: typeString.lowercased()) {
            type = checkType
        }
        
//        guard let type = ContentType(rawValue: typeString.lowercased()) else { return nil }
        let audioTracks: [AudioPlayerTrackInfo]
        if let audioTracksArray = json[ResponseKeys.audioTracks].array {
            audioTracks = audioTracksArray.compactMap { item in
                var trackName = item[ResponseKeys.audioName].stringValue
                if let extRange = trackName.range(of: ".mp3") {
                    trackName.removeSubrange(extRange)
                }
                
                return AudioPlayerTrackInfo(trackName: trackName, artistName: "", duration: "0:00", path: .remote(item[ResponseKeys.audioURL].stringValue)) }
        } else {
            audioTracks = []
        }
        
        let audioPreviews: [AudioPlayerTrackInfo]
        if let audioTracksArray = json[ResponseKeys.audioPreviews].array {
            audioPreviews = audioTracksArray.compactMap { item in
                var trackName = item[ResponseKeys.audioName].stringValue
                if let extRange = trackName.range(of: ".mp3") {
                    trackName.removeSubrange(extRange)
                }
                
                return AudioPlayerTrackInfo(trackName: trackName, artistName: "", duration: "0:00", path: .remote(item[ResponseKeys.audioURL].stringValue)) }
        } else {
            audioPreviews = []
        }
        
        let document = json[ResponseKeys.document]
        let documentURL: FilePath?
        
        if let url = document[ResponseKeys.documentURL].string {
            documentURL = .remote(url)
        } else {
            documentURL = nil
        }
        
        let documentPreview = json[ResponseKeys.documentPreview]
        var documetnPreviewURL: String?
        if let url = documentPreview[ResponseKeys.documentURL].string {
            documetnPreviewURL = url
        }
        
        let durationRead = json[ResponseKeys.durationRead].int ?? 0
        let forCategoryPresentation = json[ResponseKeys.forCategoryPresentation].bool ?? false
        
        return ActivityContent(id: id,
                               position: json[ResponseKeys.position].intValue,
                               type: type,
                               title: title,
                       body: body,
                       authorName: authorName,
                       footer: footer,
                       durtionRead: durationRead,
                       pointOfUnlock: pointOfUnlock,
                       contentStatus: contentStatus,
                       imageURL: json[ResponseKeys.imageURL].string,
                       smallImageURL: json[ResponseKeys.smallImageURL].string,
                       largeImageURL: json[ResponseKeys.largeImageURL].string,
                       likesCount: likesCount,
                       authorPhotoURL: json[ResponseKeys.authorPhotoURL].string,
                       audioTracks: audioTracks,
                       audioPreviews: audioPreviews,
                       documentURL: documentURL,
                       documentPreviewURL: documetnPreviewURL,
                       forCategoryPresentation: forCategoryPresentation,
                       color: json[ResponseKeys.color].string,
                       animationKey: json[ResponseKeys.animationKey].string)
    }
    
    static func map(content: Content) -> ActivityContent? {
        guard let type = ContentType(rawValue: content.type ?? "") else { return nil }
        let audioFilesMO: [File] = content.files?.filter { $0.type == FileType.mp3.rawValue } ?? []
        let tracks: [AudioPlayerTrackInfo] = audioFilesMO.compactMap { file in
            let filePath: FilePath
            if let path = file.path {
                filePath = .local(path)
            } else {
                filePath = .remote(file.url ?? "")
            }
            return AudioPlayerTrackInfo(trackName: file.name ?? "",
                                        artistName: "",
                                        duration: "0:00",
                                        path: filePath)
            }
        let pdfDocument = content.files?.first(where: { $0.type == FileType.pdf.rawValue })
        let documentURL: FilePath?
        
        if let path = pdfDocument?.path {
            documentURL = .local(path)
        } else if let url = pdfDocument?.url {
            documentURL = .remote(url)
        } else {
            documentURL = nil
        }
        
        /// Setup content status in according to premium subscriiption
        var contentStatus: ContentStatus = content.isLock ? .locked : .unlocked
        if DataSource.shared.isPremiumUser() { contentStatus = .unlocked }
        
        return ActivityContent(id: Int(content.id),
                               position: 0,
                               type: type,
                               title: content.title ?? "",
                               body: content.type ?? "",
                               authorName: content.authorName ?? "",
                               footer: content.footer ?? "",
                               durtionRead: Int(content.durationRead),
                               pointOfUnlock: Int(content.pointsUnlock),
                               contentStatus: contentStatus,
                               imageURL: content.imageUrl,
                               smallImageURL: content.smallImage,
                               largeImageURL: content.largeImage,
                               likesCount: Int(content.likesCount),
                               authorPhotoURL: content.authorPhotoUrl,
                               audioTracks: tracks,
                               audioPreviews: [],
                               documentURL: documentURL,
                               documentPreviewURL: nil,
                               forCategoryPresentation: false,
                               color: nil,
                               animationKey: nil)
    }
    
    func saveContent() {
        DataSource.shared.saveContent(content: self)
    }
    
    func removeFromCache() {
        DataSource.shared.deleteContent(content: self)
    }
    
    func likeContent(_ isLiked: Bool) {
    }

}

private struct ResponseKeys {
    static let id = "id"
    static let title = "title"
    static let type = "type"
    static let position = "position"
    static let typePrefix = "Content::"
    static let body = "body"
    static let authorName = "author_name"
    static let footer = "footer"
    static let pointOfUnlock = "point_of_unlock"
    static let contentStatus = "content_status"
    static let imageURL = "image_url"
    static let smallImageURL = "small_image_url"
    static let largeImageURL = "large_image_url"
    static let likesCount = "likes_count"
    static let authorPhotoURL = "author_photo_url"
    static let audioTracks = "audios"
    static let audioName = "name"
    static let audioURL = "url"
    static let document = "document"
    static let documentURL = "url"
    static let durationRead = "duration_read"
    static let forCategoryPresentation = "for_category_presentation"
    static let audioPreviews = "audio_previews"
    static let documentPreview = "document_preview"
    static let color = "color"
    static let animationKey = "animation_key"
}
