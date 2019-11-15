//
//  ArchivedGoalsPresenter.swift
//  Bold
//
//  Created by Alexander Kovalov on 8/27/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation

enum ArchievedGoalType {
    case all
    case completed
    case failed
}

enum ArchivedGoalsPresenterInput {
    case close
    case createDataSource(ArchievedGoalType)
    case selectdItem(Goal?)
}

protocol ArchivedGoalsPresenterInputProtocol:PresenterProtocol {
    func input(_ inputCase:ArchivedGoalsPresenterInput)
}

class ArchivedGoalsPresenter: ArchivedGoalsPresenterInputProtocol {
    
    typealias View = ArchivedGoalsViewController
    typealias Interactor = ArchivedGoalsInteractor
    typealias Router = ArchivedGoalsRouter
    
    weak var viewController: ArchivedGoalsViewController!
    var interactor: ArchivedGoalsInteractor!
    var router: ArchivedGoalsRouter!
    
    var dataSourceAll = [GoalCollectionViewModel]()
    var dataSource = [GoalCollectionViewModel]() {
        didSet {
            viewController.collectionView.reloadData()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
    }
    
    required init(view: View) {
        self.viewController = view
    }
    
    func input(_ inputCase: ArchivedGoalsPresenterInput) {
        switch inputCase {
        case .close:
            router.input(.close)
        case .createDataSource(let type):
            createDataSource(type: type)
        case .selectdItem(let goal):
            selectGoalAction(goal)
        }
    }
    
    private func createDataSource(type: ArchievedGoalType) {
        
        switch type {
        case .all:
            if dataSourceAll.isEmpty {
                interactor.input(.createDataSource({[weak self] goalDataSource in
                    self?.dataSourceAll = goalDataSource
                    self?.dataSource = goalDataSource
                }))
            }else {
                dataSource = dataSourceAll
            }
        case .completed:
            dataSource = dataSourceAll.filter({ (goalModel) -> Bool in
                return goalModel.goal.status == StatusType.completed.rawValue
            })
        case .failed:
            dataSource = dataSourceAll.filter({ (goalModel) -> Bool in
                return goalModel.goal.status == StatusType.failed.rawValue
            })
        }
    }
    
    private func selectGoalAction(_ selectGoal: Goal?) {
        
        guard let goal = selectGoal else { return }
        print("Goal - \(goal)")
    }
    
}
