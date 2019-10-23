//
//  ActionsListPresenter.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/22/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation

enum ActionsListPresenterInput {
    case prepareDataSource(type: FeelTypeCell, completion: (([ActionEntity]) -> Void))
    case back
    case info
    case unlockActionCard
    case share
    case download
    case like
    case addActionPlan
    case start
    case unlockListenPreview
    case unlockReadPreview
    case listenPreview
    case readPreview
}

protocol ActionsListPresenterProtocol {
    func input(_ inputCase: ActionsListPresenterInput)
}

class ActionsListPresenter: PresenterProtocol, ActionsListPresenterProtocol {
    
    typealias View = ActionsListViewController
    typealias Interactor = ActionsListInteractor
    typealias Router = ActionsListRouter
    
    weak var viewController: ActionsListViewController!
    var interactor: ActionsListInteractor!
    var router: ActionsListRouter!
    
    required init(view: View) {
        self.viewController = view
    }
    
    required init?(coder aDecoder: NSCoder) {
        
    }
    
    func input(_ inputCase: ActionsListPresenterInput) {
        
        switch inputCase {
        case .prepareDataSource(type: let type, completion: let completion):
            prepareDataSource(type: type, completion: completion)
        case .back:
            router.input(.back)
        case .info:
            router.input(.info)
        case .unlockActionCard:
            print("dsf")
        case .share:
            viewController.shareContent(item: nil)
        case .download:
            print("dow")
        case .like:
            print("dsf")
        case .addActionPlan:
            let vc = AddActionPlanViewController.createController {
                print("create add action")
            }
            router.input(.presentedBy(vc))
        case .start:
            print("Start")
        case .unlockListenPreview:
            print("unlockListenPreview")
        case .unlockReadPreview:
            print("unlockReadPreview")
        case .listenPreview:
            print("listenPreview")
        case .readPreview:
            print("readPreview")
        }
    }
    
    private func prepareDataSource(type: FeelTypeCell, completion: (([ActionEntity]) -> Void)?) {
        interactor.input(.prepareDataSource(contentType: getContentType(by: type)) { content in
            let actions = content.compactMap { ActionEntity(type: .action, header: $0.contentStatus == .locked ? .unlock : .points , download: false, like: false, data: $0) }
            completion?(actions)
        })
    }
    
    private func getContentType(by type: FeelTypeCell) -> ContentType {
        switch type {
        case .citate:
            return .quote
        case .hypnosis:
            return .hypnosis
        case .lessons:
            return .lesson
        case .meditation:
            return .meditation
        case .pepTalk:
            return .preptalk
        case .stories:
            return .story
        }
    }
    
}


class ActionEntity: NSObject {
    var type : ActionCellType
    var header : HeaderType?
    var download : Bool
    var like : Bool
    var data: Content
    
    init(type: ActionCellType, header: HeaderType?, download: Bool, like: Bool, data: Content) {
        self.type = type
        self.header = header
        self.download = download
        self.like = like
        self.data = data
    }
}
