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
    var pointOfUnlock: Int
    var contentStatus: ContentStatus
    var imageURL: String?
    var smallImageURL: String?
    var largeImageURL: String?
    var likesCount: Int
    var authorPhotoURL: String?
    var audiosURLs: [String]
    var documentURL: String?
    
    static func mapJSON(_ json: JSON) -> ActivityContent? {
        guard let id = json[ResponseKeys.id].int,
            let title = json[ResponseKeys.title].string,
            var typeString = json[ResponseKeys.type].string,
            let body = json[ResponseKeys.body].string,
            let authorName = json[ResponseKeys.authorName].string,
            let footer = json[ResponseKeys.footer].string,
            let pointOfUnlock = json[ResponseKeys.pointOfUnlock].int,
            let contentStatusString = json[ResponseKeys.contentStatus].string,
            let contentStatus = ContentStatus(rawValue: contentStatusString.lowercased()),
            let likesCount = json[ResponseKeys.likesCount].int
            else { return nil }
        if typeString.hasPrefix(ResponseKeys.typePrefix) {
            typeString = String(typeString.dropFirst(ResponseKeys.typePrefix.count))
        }
        guard let type = ContentType(rawValue: typeString.lowercased()) else { return nil }
        let audiosURL: [String]
        if let audiosURLsString = json[ResponseKeys.audiosURLs].string,
            !audiosURLsString.isEmpty {
            audiosURL = audiosURLsString.split(separator: ",").compactMap { String($0) }
        } else {
            audiosURL = []
        }
        return ActivityContent(id: id,
                       title: title,
                       type: type,
                       body: body,
                       authorName: authorName,
                       footer: footer,
                       pointOfUnlock: pointOfUnlock,
                       contentStatus: contentStatus,
                       imageURL: json[ResponseKeys.imageURL].string,
                       smallImageURL: json[ResponseKeys.smallImageURL].string,
                       largeImageURL: json[ResponseKeys.largeImageURL].string,
                       likesCount: likesCount,
                       authorPhotoURL: json[ResponseKeys.authorPhotoURL].string,
                       audiosURLs: audiosURL,
                       documentURL: json[ResponseKeys.documentURL].string)
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
    static let audiosURLs = "audios_url"
    static let documentURL = "document_url"
}
