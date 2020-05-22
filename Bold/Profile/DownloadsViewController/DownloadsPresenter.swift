//
//  DownloadsPresenter.swift
//  Bold
//
//  Created by Alexander Kovalov on 8/27/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

enum DownloadsPresenterInput {
    case close
    case prepareDataSource(completion: (([ActivityContent]) -> Void))
    case showDetails(ActivityContent)
    case addActionPlan(ActivityContent)
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
        case .addActionPlan(let content):
            addActionPlan(content: content)
        }
    }
    
    private func addActionPlan(content: ActivityContent) {
//        let vc = AddActionPlanViewController.createController {
//            print("add action plan tap ok")
//        }
//        vc.contentID = String(content.id)
//        let currentVC = UIApplication.topViewController ?? viewController
//        currentVC?.present(vc, animated: true)
        
        AlertViewService.shared.input(.addAction(content: content, tapAddPlan: {
            print("sdfsdf")
        }))
    }
    
    private func showDetails(content: ActivityContent) {
        switch content.type {
        case .hypnosis, .meditation, .peptalk:
            showPlayer(content: content)
        case .lesson, .story:
            showDescription(content: content)
        case .quote:
            break
        }
    }
    
    private func showPlayer(content: ActivityContent) {
        
        PlayerViewController.createController(content: content)
    }
    
    private func showDescription(content: ActivityContent) {
        let descriptionVC = StoryboardScene.Description.descriptionAndLikesCountViewController.instantiate()
        descriptionVC.viewModel = DescriptionViewModel.map(activityContent: content)
        descriptionVC.isDownloadedContent = DataSource.shared.contains(content: content)
//        descriptionVC.audioPlayerDelegate = viewController
        viewController.navigationController?.present(descriptionVC, animated: true)
    }
    
}
