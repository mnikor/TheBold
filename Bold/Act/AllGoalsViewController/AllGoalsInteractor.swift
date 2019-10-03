//
//  AllGoalsInteractor.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/22/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation
import UIKit
import CoreData

enum AllGoalsInputInteractor {
    case createDataSource(([GoalCollectionViewModel])->Void)
}

protocol AllGoalsInputInteractorProtocol {
    func input(_ inputCase: AllGoalsInputInteractor)
}

class AllGoalsInteractor: InteractorProtocol, AllGoalsInputInteractorProtocol {

    typealias Presenter = AllGoalsPresenter
    
    weak var presenter: Presenter!
    
    required init(presenter: Presenter) {
        self.presenter = presenter
    }
    
    func input(_ inputCase: AllGoalsInputInteractor) {
        switch inputCase {
        case .createDataSource(let success):
            createDataSource(success: success)
        }
    }
    
    func createDataSource(success: ([GoalCollectionViewModel])->Void) {
        
        DataSource.shared.goalsListForRead {(goalList) in
            let dataSource = goalList.compactMap { (goal) -> GoalCollectionViewModel in
                return GoalCollectionViewModel.createGoalModel(goal: goal)
            }
            success(dataSource)
        }
    }
    
}

