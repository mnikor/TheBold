//
//  DescriptionViewModel.swift
//  Bold
//
//  Created by Admin on 06.11.2019.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

struct DescriptionViewModel {
    var image: Image
    var documentURL: URL?
    var likesCount: Int?
    var title: String?
    var category: ContentType?
    var audioTracks: [AudioPlayerTrackInfo]
    var isLikesEnabled: Bool
    
    static func map(activityContent: ActivityContent) -> DescriptionViewModel {
        let documentURL: URL?
        switch activityContent.documentURL {
        case .local(let path):
            documentURL = URL(fileURLWithPath: path)
        case .remote(let urlString):
            documentURL = URL(string: urlString)
        case nil:
            documentURL = nil
        }
        return DescriptionViewModel(image: .path(activityContent.imageURL),
                                    documentURL: documentURL,
                                    likesCount: activityContent.likesCount,
                                    title: activityContent.title,
                                    category: activityContent.type,
                                    audioTracks: activityContent.audioTracks,
                                    isLikesEnabled: true)
    }
    
    static func map(feelType: FeelTypeCell) -> DescriptionViewModel {
        return DescriptionViewModel(image: .image(feelType.descriptionImage),
                                    documentURL: feelType.documentURL,
                                    likesCount: nil,
                                    title: nil,
                                    category: nil,
                                    audioTracks: [],
                                    isLikesEnabled: false)
    }
    
    static var boldManifestInfo: DescriptionViewModel {
        return DescriptionViewModel(image: .image(Asset.boldManifestMain.image),
                                    documentURL: Bundle.main.url(forResource: "Manifest", withExtension: "pdf"),
                                    likesCount: nil,
                                    title: nil,
                                    category: nil,
                                    audioTracks: [AudioPlayerTrackInfo(trackName: "Bold Manifest",
                                                                       artistName: "",
                                                                       duration: "4:07",
                                                                       path: .local(Bundle.main.path(forResource: "Bold Manifest ",
                                                                                                     ofType: "mp3") ?? ""))],
                                    isLikesEnabled: false)
    }
    
    static var privacyPolicy: DescriptionViewModel {
        return DescriptionViewModel(image: .image(Asset.privacyHeader.image),
                                    documentURL: Bundle.main.url(forResource: "Privacy", withExtension: "pdf"),
                                    likesCount: nil,
                                    title: "Privacy policy",
                                    category: nil,
                                    audioTracks: [],
                                    isLikesEnabled: false)
    }
    
    static var termsOfUse: DescriptionViewModel {
        return DescriptionViewModel(image: .image(Asset.privacyHeader.image),
                                    documentURL: Bundle.main.url(forResource: "Terms", withExtension: "pdf"),
                                    likesCount: nil,
                                    title: "Terms & Conditions",
                                    category: nil,
                                    audioTracks: [],
                                    isLikesEnabled: false)
    }
    
}

enum Image {
    case image(UIImage?)
    case path(String?)
}