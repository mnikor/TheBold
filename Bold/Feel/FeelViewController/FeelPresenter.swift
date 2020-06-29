//
//  FeelPresenter.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/22/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation

enum FeelPresenterInput  {
    case menuShow
    case showAll(FeelTypeCell)
    case showDetails(item: ActivityContent)
    case prepareDataSource(types: [ContentType], completion: (([FeelEntity]) -> Void)?)
    case addActionPlan(ActivityContent)
}

protocol FeelPresenterProtocol {
    func input(_ inputCase: FeelPresenterInput)
}

class FeelPresenter: PresenterProtocol, FeelPresenterProtocol {
    
    typealias View = FeelViewController
    typealias Interactor = FeelInteractor
    typealias Router = FeelRouter
    
    weak var viewController: View!
    var interactor: Interactor!
    var router: Router!
    
    required init(view: View) {
        self.viewController = view
    }
    
    required init?(coder aDecoder: NSCoder) {
        
    }
    
    func input(_ inputCase: FeelPresenterInput) {
        switch inputCase {
        case .menuShow:
            router.input(.menuShow)
        case .showAll(let typeCell):
            router.input(.showAll(typeCell))
        case .showDetails(item: let content):
            showDetails(for: content)
        case .prepareDataSource(types: let types, completion: let completion):
            prepareDataSource(types: types, completion: completion)
        case .addActionPlan(let content):
//            let vc = AddActionPlanViewController.createController {
//                print("create add action")
//            }
//            vc.contentID = String(content.id)
            
            AlertViewService.shared.input(.addAction(content: content, tapAddPlan: {
                print("create add action")
            }))
            
//            interactor.input(.downloadContent(content))
            
//            router.input(.present(vc))
        }
    }
    
    private func prepareDataSource(types: [ContentType], completion: (([FeelEntity]) -> Void)?) {
        interactor.input(.prepareDataSource(contentTypeArray: types, completion: { [weak self] result in
            guard let self = self else { return }
            let sortedResult = result.sorted { (content1, content2) -> Bool in
                let content1Index = types.firstIndex(of: content1.key) ?? 0
                let content2Index = types.firstIndex(of: content2.key) ?? 0
                return content1Index < content2Index
            }
            let entities = sortedResult.compactMap { FeelEntity(type: self.getCellType(by: $0.key), items: $0.value) }
            completion?(entities)
        }))
    }
    
    private func getCellType(by contentType: ContentType) -> FeelTypeCell {
        switch contentType {
        case .hypnosis:
            return .hypnosis
        case .lesson:
            return .lessons
        case .meditation:
            return .meditation
        case .peptalk:
            return .pepTalk
        case .quote:
            return .citate
        case .story:
            return .stories
        }
    }
    
    private func showDetails(for content: ActivityContent) {
        let isDownloadedContent = DataSource.shared.contains(content: content)
        if isContentStatusLocked(content: content) {
            /// show premium content
            router.showPremiumController()
        } else {
            switch content.type {
            case .lesson, .story:
                let vc = StoryboardScene.Description.descriptionAndLikesCountViewController.instantiate()
                vc.viewModel = DescriptionViewModel.map(activityContent: content)
                vc.isDownloadedContent = isDownloadedContent
                router.input(.present(vc))
            default:
                interactor.input(.prepareTracks(content: content))
                router.input(.showPlayer(isPlaying: content.type != .meditation, isDownloadedContent: isDownloadedContent, content: content))
            }
        }
    }
    
    private func isContentStatusLocked(content: ActivityContent) -> Bool {
        if content.contentStatus == .locked || content.contentStatus == .lockedPoints {
            return true
        } else {
            return false
        }
    }
}

struct FeelEntity {
    var type : FeelTypeCell
    var items: Array<ActivityContent>
}
