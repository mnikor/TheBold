//
//  DownloadsPresenter.swift
//  Bold
//
//  Created by Alexander Kovalov on 8/27/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation

enum DownloadsPresenterInput {
    case close
    case prepareDataSource(completion: (([ActivityContent]) -> Void))
    case showDetails(ActivityContent)
}

protocol DownloadsPresenterInputProtocol: PresenterProtocol {
    func input(_ inputCase: DownloadsPresenterInput)
}

class DownloadsPresenter: DownloadsPresenterInputProtocol {
    
    typealias View = DownloadsViewController
    typealias Interactor = DownloadsInteractor
    typealias Router = DownloadsRouter
    
    weak var viewController: View!
    var interactor: Interactor!
    var router: Router!
    
    required init?(coder aDecoder: NSCoder) {
        
    }
    
    required init(view: View) {
        self.viewController = view
    }
    
    func input(_ inputCase: DownloadsPresenterInput) {
        switch inputCase {
        case .close:
            router.input(.close)
        case .prepareDataSource(completion: let completion):
            interactor.input(.prepareDataSource(completion: completion))
        case .showDetails(let content):
            showDetails(content: content)
        }
    }
    
    private func showDetails(content: ActivityContent) {
        switch content.type {
        case .hypnosis, .meditation, .preptalk:
            showPlayer(content: content)
        case .lesson, .story:
            showDescription(content: content)
        case .quote:
            break
        }
    }
    
    private func showPlayer(content: ActivityContent) {
        AudioService.shared.tracks = content.audioTracks
        AudioService.shared.startPlayer(isPlaying: content.type != .meditation,
                                        isDownloadedContent: DataSource.shared.contains(content: content))
        AudioService.shared.playerDelegate = viewController
    }
    
    private func showDescription(content: ActivityContent) {
        let descriptionVC = StoryboardScene.Description.descriptionAndLikesCountViewController.instantiate()
        descriptionVC.viewModel = DescriptionViewModel.map(activityContent: content)
        descriptionVC.isDownloadedContent = DataSource.shared.contains(content: content)
        descriptionVC.audioPlayerDelegate = viewController
        viewController.navigationController?.present(descriptionVC, animated: true)
    }
    
}
