//
//  HomePresenter.swift
//  Bold
//
//  Created by Alexander Kovalov on 6/14/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation

enum HomePresenterInput {
    case menuShow
    case actionAll(HomeActionsTypeCell)
    case actionItem(ActivityViewModel, Int)
    case unlockBoldManifest
    case createGoal
}

protocol HomePresenterInputProtocol {
    func input(_ inputCase: HomePresenterInput)
}

class HomePresenter: PresenterProtocol, HomePresenterInputProtocol {
    
    typealias View = HomeViewController
    typealias Interactor = HomeInteractor
    typealias Router = HomeRouter
    
    weak var viewController: View!
    var interactor: Interactor!
    var router: Router!
    
    required init(view: View) {
        self.viewController = view
        prepareDataSource()
    }
    
    required init?(coder aDecoder: NSCoder) {
        prepareDataSource()
    }
    
    var actionItems: [ActivityViewModel] = []
    
    private var feelContent: [FeelTypeCell] = [.meditation, .hypnosis, .pepTalk]
    private var thinkContent: [FeelTypeCell] = [.stories, .citate, .lessons]
    
    func input(_ inputCase: HomePresenterInput) {
        
        switch inputCase {
        case .menuShow:
            router.input(.menuShow)
        case .actionAll(let type):
            router.input(.actionAll(type))
        case .actionItem(let viewModel, let index):
            actionItem(viewModel: viewModel, at: index)
        case .unlockBoldManifest:
            router.input(.unlockBoldManifest)
        case .createGoal:
            router.input(.createGoal)
        }
    }
    
    private func actionItem(viewModel: ActivityViewModel, at index: Int) {
        switch viewModel.type {
        case .feel:
            let item = feelContent[index]
            router.input(.actionItem(item))
        case .think:
            let item = thinkContent[index]
            router.input(.actionItem(item))
        default:
            break
        }
    }
    
    private func prepareDataSource() {
        let feel = ActivityViewModel.createViewModel(type: .feel,
                                                     goals: [],
                                                     content: feelContent.compactMap { ContentViewModel(backgroundImage: nil, title: $0.titleText() ?? "") },
                                                     itemCount: feelContent.count)
        let boldManifest = ActivityViewModel.createViewModel(type: .boldManifest,
                                                             goals: [],
                                                             content: [],
                                                             itemCount: 0)
        let think = ActivityViewModel.createViewModel(type: .think,
                                                      goals: [],
                                                      content: thinkContent.compactMap { ContentViewModel(backgroundImage: nil, title: $0.titleText() ?? "") },
                                                      itemCount: thinkContent.count)
        let actActive = ActivityViewModel.createViewModel(type: .actActive,
                                                         goals: [],
                                                         content: [],
                                                         itemCount: 0)
        let actNotActive = ActivityViewModel.createViewModel(type: .actNotActive,
                                                             goals: [],
                                                             content: [],
                                                             itemCount: 0)
        actionItems = [feel, boldManifest, think, actActive, actNotActive]
    }
    
}


