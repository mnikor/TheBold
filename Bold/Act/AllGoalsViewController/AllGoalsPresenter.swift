//
//  AllGoalsPresenter.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/22/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation

enum AllGoalsInputPresenter {
    case addGoal
    case selectdItem(Goal?)
    case createDataSource
}

protocol AllGoalsInputPresenterProtocol {
    func input(_ inputCase: AllGoalsInputPresenter)
}

class AllGoalsPresenter: PresenterProtocol, AllGoalsInputPresenterProtocol {
    
    typealias View = AllGoalsViewController
    typealias Interactor = AllGoalsInteractor
    typealias Router = AllGoalsRouter
    
    weak var viewController: View!
    var interactor: Interactor!
    var router: Router!
    
    var dataSource = [GoalCollectionViewModel]()
    
    required init(view: View) {
        self.viewController = view
    }
    
    required init?(coder aDecoder: NSCoder) {
        
    }
    
    func input(_ inputCase: AllGoalsInputPresenter) {
        switch inputCase {
        case .addGoal:
            router.input(.addGoal)
        case .selectdItem(let selectGoal):
            if let goal = selectGoal {
                router.input(.selectGoal(goal))
            }
        case .createDataSource:
            interactor.input(.createDataSource({[weak self] goalDataSource in
                self?.dataSource = goalDataSource
                self?.viewController.collectionView.reloadData()
            }))
        }
    }
    
}
