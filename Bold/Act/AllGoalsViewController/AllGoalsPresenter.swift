//
//  AllGoalsPresenter.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/22/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

enum AllGoalsInputPresenter {
    case addGoal
    case selectdItem(Goal?)
    case createDataSource
    case subscribeToUpdate
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
    
    let disposeBag = DisposeBag()
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
            selectGoalAction(selectGoal)
        case .createDataSource:
            interactor.input(.createDataSource({[weak self] goalDataSource in
                self?.dataSource = goalDataSource
                self?.viewController.collectionView.reloadData()
            }))
        case .subscribeToUpdate:
            subscribeToUpdate()
        }
    }
    
    private func selectGoalAction(_ selectGoal: Goal?) {
        
        guard let goal = selectGoal else { return }
        
        if goal.status == StatusType.locked.rawValue {
            AlertViewService.shared.input(.missedYourActionLock(tapUnlock: {
                LevelOfMasteryService.shared.input(.unlockGoal(goalID: goal.id!))
            }))
        }else {
            router.input(.selectGoal(goal))
        }
    }
    
    private func subscribeToUpdate() {
        
        DataSource.shared.changeContext.subscribe(onNext: {[weak self] (_) in
            self?.input(.createDataSource)
        }).disposed(by: disposeBag)
    }
    
}
