//
//  ManifestPresenter.swift
//  Bold
//
//  Created by Alexander Kovalov on 6/21/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation
import UIKit

enum ManifestPresenterInput {
    case tapCloseButton
    case tapPlayVideo(String)
    case tapPauseVideo
}

protocol ManifestPresenterProtocol: PresenterProtocol {
    func input(_ inputCase: ManifestPresenterInput)
}

class ManifestPresenter: PresenterProtocol, ManifestPresenterProtocol {
    
    typealias View = ManifestViewController
    typealias Interactor = ManifestInteractor
    typealias Router = ManifestRouter
    
    weak var viewController: View!
    var interactor: Interactor!
    var router: Router!
    var state: ManifestViewControllerState!
    
    required init(view: ManifestViewController) {
        self.viewController = view
    }
    
    required init?(coder aDecoder: NSCoder) {
        
    }
    
    func input(_ inputCase: ManifestPresenterInput) {
        switch inputCase {
        case .tapCloseButton:
            router.input(.close)
        case .tapPlayVideo(let videoName):
            state = ManifestViewControllerState(view: viewController.playerView)
            interactor.input(.tapPlayVideo(videoName))
            interactor.input(.tapPauseVideo)
        case .tapPauseVideo:
            interactor.input(.tapPauseVideo)
        }
    }
    
}

struct ManifestViewControllerState {
    var view: UIView
}
