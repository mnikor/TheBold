//
//  LevelOfMasteryInteractor.swift
//  Bold
//
//  Created by Alexander Kovalov on 8/27/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation

enum LevelOfMasteryInteractorInput {
    case createDataSource(completed: Callback<[LevelOfMasteryEntity]>)
}

protocol LevelOfMasteryInteractorInputProtocol: InteractorProtocol {
    func input(_ inputCase: LevelOfMasteryInteractorInput)
}

class LevelOfMasteryInteractor: LevelOfMasteryInteractorInputProtocol {
    
    typealias Presenter = LevelOfMasteryPresenter
    
    weak var presenter: Presenter!
    
    required init(presenter: Presenter) {
        self.presenter = presenter
    }
    
    func input(_ inputCase: LevelOfMasteryInteractorInput) {
        
        switch inputCase {
        case .createDataSource(completed: let completed):
            createDataSource(completed: completed)
        }
    }
    
    func createDataSource(completed:@escaping Callback<[LevelOfMasteryEntity]>) {
        
        LevelOfMasteryService.shared.input(.getAllLevels(levels: { (levels) in
            
            let levelsBold = levels.compactMap { (level) -> LevelOfMasteryEntity in
                return self.createLevelEntity(level: level)
            }
            completed(levelsBold)
            
        }))
    }
    
    func createLevelEntity(level: LevelBold) -> LevelOfMasteryEntity {

        return LevelOfMasteryEntity(type: level.type,
                                    isLock: StatusLevelsType.disable == level.status,
                                    progress: level.completionPercentage,
                                    params: createCheckLimitLevel(limitsLevel: level.limits))
    }
    
    func createCheckLimitLevel(limitsLevel: LimitsLevel) -> [CheckLevelEntity] {
        
        var limits = [CheckLevelEntity]()
        
        if case .points(let points) = limitsLevel.limitPoint.type {
            let limit = limitsLevel.limitPoint
            limits.append(CheckLevelEntity(checkPoint: limit.completed, titleText: limit.description, points: points))
        }
        
        for limit in limitsLevel.limitsGoal {
            if limit.completed == true {
                limits.append(CheckLevelEntity(checkPoint: limit.completed, titleText: limit.description, points: 0))
                break
            }
            limits.append(CheckLevelEntity(checkPoint: limit.completed, titleText: limit.description, points: 0))
            break
        }

        return limits
    }
    
}
