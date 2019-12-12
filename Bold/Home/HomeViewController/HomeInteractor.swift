//
//  HomeInteractor.swift
//  Bold
//
//  Created by Alexander Kovalov on 6/14/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation

enum HomeInteractorInput {
    case prepareDataSource(([ActivityViewModel]) -> Void)
    case getFeelType(type: HomeActionsTypeCell, index: Int, completion: ((FeelTypeCell?) -> Void))
}

protocol HomeInteractorInputProtocol: InteractorProtocol {
    func input(_ inputCase: HomeInteractorInput)
}

class HomeInteractor: HomeInteractorInputProtocol {
    
    typealias Presenter = HomePresenter
    
    weak var presenter: Presenter!
    
    private var feelContent: [FeelTypeCell] = [.meditation, .pepTalk, .hypnosis]
    private var thinkContent: [FeelTypeCell] = [.lessons, .stories, .citate]
    
    required init(presenter: Presenter) {
        self.presenter = presenter
    }
    
    func input(_ inputCase: HomeInteractorInput) {
        switch inputCase {
        case .prepareDataSource(let completion):
            prepareDataSource(completion: completion)
        case .getFeelType(type: let type, index: let index, completion: let completion):
            getFeelType(type: type, index: index, completion: completion)
        }
    }
    
    private func getFeelType(type: HomeActionsTypeCell, index: Int, completion: @escaping ((FeelTypeCell?) -> Void)) {
        let feelType: FeelTypeCell?
        switch type {
        case .feel:
            feelType = feelContent[index]
        case .think:
            feelType = thinkContent[index]
        default:
            feelType = nil
        }
        completion(feelType)
    }
    
    private func prepareDataSource(completion: @escaping ([ActivityViewModel])-> Void) {
          let feel = ActivityViewModel.createViewModel(type: .feel,
                                                       goals: [],
                                                       content: feelContent.compactMap { ContentViewModel(backgroundImage: $0.categoryImage(),
                                                                                                          title: $0.categoryName()) },
                                                       itemCount: feelContent.count)
          let boldManifest = ActivityViewModel.createViewModel(type: .boldManifest,
                                                               goals: [],
                                                               content: [],
                                                               itemCount: 0)
          let think = ActivityViewModel.createViewModel(type: .think,
                                                        goals: [],
                                                        content: thinkContent.compactMap { ContentViewModel(backgroundImage: $0.categoryImage(),
                                                                                                            title: $0.categoryName()) },
                                                        itemCount: thinkContent.count)
        DataSource.shared.goalsListForRead(success: { goals in
            let actActive = ActivityViewModel.createViewModel(type: .actActive,
                                                              goals: goals.compactMap { GoalCollectionViewModel.createGoalModel(goal: $0) },
                                                              content: [],
                                                              itemCount: goals.count)
            completion([feel, boldManifest, think, actActive])
        })
         
    }
    
}
