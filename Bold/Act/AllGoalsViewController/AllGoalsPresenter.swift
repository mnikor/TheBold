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
    case selectdItem(GoalEntity)
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
    
    lazy var goalItems : [GoalEntity] = {
        return [GoalEntity(type: .launchStartUp, active: .locked, progress: 0, total: 0),
                GoalEntity(type: .Community, active: .active, progress: 2, total: 5),
                GoalEntity(type: .Marathon, active: .active, progress: 3, total: 4),
                GoalEntity(type: .BuildHouseForParents, active: .active, progress: 2, total: 7)]
    }()
    
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
            router.input(.selectGoal(selectGoal))
        }
    }
    
}


struct GoalEntity {
    var type: GoalType
    var active: GoalCellType
    var progress: Int
    var total: Int
}
