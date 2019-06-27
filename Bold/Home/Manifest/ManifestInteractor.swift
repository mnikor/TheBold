//
//  ManifestInteractor.swift
//  Bold
//
//  Created by Alexander Kovalov on 6/21/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation
import UIKit

enum ManifestInteractorInput {
    case tapPlayVideo(String)
    case tapPauseVideo
}

protocol ManifestInteractorProtocol: InteractorProtocol {
    func input(_ inputCase: ManifestInteractorInput)
}

class ManifestInteractor: InteractorProtocol, ManifestInteractorProtocol {
    
    typealias Presenter = ManifestPresenter
    
    weak var presenter: Presenter!
    var videoService: VideoServiceProtocol = VideoService()
    
    required init(presenter: ManifestPresenter) {
        self.presenter = presenter
    }
    
    func input(_ inputCase: ManifestInteractorInput) {
        switch inputCase {
        case .tapPlayVideo(let videoName):
            videoService.view = presenter.state.view
            videoService.input(.play(videoName: videoName))
        case .tapPauseVideo:
            videoService.input(.pause)
        }
    }
}
