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
    var documentPreviewURL: URL?
    var likesCount: Int?
    var title: String?
    var category: ContentType?
    var audioTracks: [AudioPlayerTrackInfo]
    var isLikesEnabled: Bool
    var toolbarIsHidden: Bool = false
    var content: ActivityContent? = nil
    
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
                                    isLikesEnabled: true,
                                    content: activityContent)
    }
    
    static func map(feelType: FeelTypeCell) -> DescriptionViewModel {
        return DescriptionViewModel(image: .image(feelType.descriptionImage),
                                    documentURL: feelType.documentURL,
                                    likesCount: nil,
                                    title: nil,
                                    category: nil,
                                    audioTracks: [],
                                    isLikesEnabled: false,
                                    toolbarIsHidden: true)
    }
    
    static var boldManifestInfo: DescriptionViewModel {
        let documentURL = Bundle.main.url(forResource: "Manifest", withExtension: "pdf")
        let audio = AudioPlayerTrackInfo(trackName: "Bold Manifest",
                                         artistName: "",
                                         duration: "4:07",
                                         path: .local(Bundle.main.path(forResource: "Bold Manifest ", ofType: "mp3") ?? ""))

        var path = ""
        
        if let resourcePath = Bundle.main.resourcePath {
            let imageName = "boldManifestMain.png"
            path = resourcePath + "/" + imageName
        }
        
        let content = ActivityContent(id: 0, position: 0, type: ContentType.hypnosis, title: "", body: "", authorName: "", footer: "", durtionRead: 307, pointOfUnlock: 0, contentStatus: ContentStatus.unlocked, imageURL: path, smallImageURL: path, largeImageURL: path, likesCount: 0, authorPhotoURL: nil, audioTracks: [audio], audioPreviews: [], documentURL: FilePath.local (documentURL?.absoluteString ?? ""), documentPreviewURL: nil, forCategoryPresentation: false, color: nil, animationKey: nil)
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
                                    isLikesEnabled: false,
                                    toolbarIsHidden: true,
        content: content)
    }
    
    static var privacyPolicy: DescriptionViewModel {
        return DescriptionViewModel(image: .image(Asset.privacyHeader.image),
                                    documentURL: Bundle.main.url(forResource: "Privacy", withExtension: "pdf"),
                                    likesCount: nil,
                                    title: "Privacy policy",
                                    category: nil,
                                    audioTracks: [],
                                    isLikesEnabled: false,
                                    toolbarIsHidden: true)
    }
    
    static var termsOfUse: DescriptionViewModel {
        return DescriptionViewModel(image: .image(Asset.privacyHeader.image),
                                    documentURL: Bundle.main.url(forResource: "Terms", withExtension: "pdf"),
                                    likesCount: nil,
                                    title: "Terms & Conditions",
                                    category: nil,
                                    audioTracks: [],
                                    isLikesEnabled: false,
                                    toolbarIsHidden: true)
    }
    
}

enum Image {
    case image(UIImage?)
    case path(String?)
}
