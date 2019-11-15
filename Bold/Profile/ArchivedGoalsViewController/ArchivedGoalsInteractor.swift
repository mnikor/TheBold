//
//  ArchivedGoalsInteractor.swift
//  Bold
//
//  Created by Alexander Kovalov on 8/27/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation

enum ArchievedGoalsInputInteractor {
    case createDataSource(Callback<[GoalCollectionViewModel]>)
}

protocol ArchivedGoalsInteractorProtocol {
    func input(_ inputCase: ArchievedGoalsInputInteractor)
}

class ArchivedGoalsInteractor: InteractorProtocol, ArchivedGoalsInteractorProtocol {
    
    typealias Presenter = ArchivedGoalsPresenter
    
    weak var presenter: Presenter!
    
    required init(presenter: Presenter) {
        self.presenter = presenter
    }
    
    func input(_ inputCase: ArchievedGoalsInputInteractor) {
        switch inputCase {
        case .createDataSource(let completed):
            createDataSource(success: completed)
        }
    }
    
    private func createDataSource(success: ([GoalCollectionViewModel])->Void) {
        
        DataSource.shared.goalsListForArchieved {(goalList) in
            let dataSource = goalList.compactMap { (goal) -> GoalCollectionViewModel in
                return GoalCollectionViewModel.createGoalModel(goal: goal)
            }
            success(dataSource)
        }
    }
}
