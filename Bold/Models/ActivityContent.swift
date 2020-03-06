//
//  Content.swift
//  Bold
//
//  Created by Admin on 21.10.2019.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import SwiftyJSON

struct ActivityContent {
    var id: Int
    var title: String
    var type: ContentType
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
    var documentURL: FilePath?
    
    static func mapJSON(_ json: JSON) -> ActivityContent? {
        let id = json[ResponseKeys.id].intValue
        let title = json[ResponseKeys.title].stringValue
        var typeString = json[ResponseKeys.type].stringValue
        let body = json[ResponseKeys.body].stringValue
        let authorName = json[ResponseKeys.authorName].stringValue
        let footer = json[ResponseKeys.footer].stringValue
        let pointOfUnlock = json[ResponseKeys.pointOfUnlock].intValue
        let contentStatusString = json[ResponseKeys.contentStatus].stringValue
        let contentStatus = ContentStatus(rawValue: contentStatusString.lowercased()) ?? ContentStatus.unlocked
        let likesCount = json[ResponseKeys.likesCount].intValue
            
        if typeString.hasPrefix(ResponseKeys.typePrefix) {
            typeString = String(typeString.dropFirst(ResponseKeys.typePrefix.count))
        }
        guard let type = ContentType(rawValue: typeString.lowercased()) else { return nil }
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
        let documentURL: FilePath?
        
        if let url = json[ResponseKeys.documentURL].string {
            documentURL = .remote(url)
        } else {
            documentURL = nil
        }
        
        let durationRead = json[ResponseKeys.durationRead].int ?? 0
        
        return ActivityContent(id: id,
                       title: title,
                       type: type,
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
                       documentURL: documentURL)
    }
    
    static func map(content: Content) -> ActivityContent? {
        guard let type = ContentType(rawValue: content.type ?? "") else { return nil }
        let audioFilesMO: [File] = content.files?.filter { $0.isAudio } ?? []
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
        let pdfDocument = content.files?.first(where: { !$0.isAudio })
        let documentURL: FilePath?
        
        if let path = pdfDocument?.path {
            documentURL = .local(path)
        } else if let url = pdfDocument?.url {
            documentURL = .remote(url)
        } else {
            documentURL = nil
        }
        
        return ActivityContent(id: Int(content.id),
                               title: content.title ?? "",
                               type: type,
                               body: content.type ?? "",
                               authorName: content.authorName ?? "",
                               footer: content.footer ?? "",
                               durtionRead: Int(content.durationRead),
                               pointOfUnlock: Int(content.pointsUnlock),
                               contentStatus: content.isLock ? .locked : .unlocked,
                               imageURL: content.imageUrl,
                               smallImageURL: content.smallImage,
                               largeImageURL: content.largeImage,
                               likesCount: Int(content.likesCount),
                               authorPhotoURL: content.authorPhotoUrl,
                               audioTracks: tracks,
                               documentURL: documentURL)
    }
    
    func saveContent() {
        DataSource.shared.saveContent(content: self)
    }
    
    func removeFromCache() {
        DataSource.shared.deleteContent(content: self)
    }
    
    func likeContent(_ isLiked: Bool) {
    }
    
    func playerStoped(with totalDuration: TimeInterval) {
        let type = self.type
        let durationInMinutes = Int(totalDuration / 60)
        boldnessChanged(duration: durationInMinutes)
        switch type {
        case .meditation:
            if durationInMinutes >= 7 {
                updatePoints()
            }
        case .hypnosis:
            if durationInMinutes >= 20 {
                updatePoints()
            }
        case .preptalk:
            if totalDuration >= 3 {
                updatePoints()
            }
        case .story:
            // TODO: - story duration
            break
        case .lesson, .quote:
            break
        }
    }
    
    private func boldnessChanged(duration: Int) {
        SettingsService.shared.boldness += duration
    }
    
    private func updatePoints() {
        LevelOfMasteryService.shared.input(.addPoints(points: 10))
    }

}

private struct ResponseKeys {
    static let id = "id"
    static let title = "title"
    static let type = "type"
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
    static let documentURL = "document_url"
    static let durationRead = "duration_read"
}
