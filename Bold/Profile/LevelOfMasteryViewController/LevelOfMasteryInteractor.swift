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
        default:
            print("dsfdsf")
        }
    }
    
    func createDataSource(completed: Callback<[LevelOfMasteryEntity]>) {
        
        LevelOfMasteryService.shared.input(.getAllLevels(levels: { (levels) in
            
            let levelsBold = levels.compactMap { (level) -> LevelOfMasteryEntity in
                return self.createLevelEntity(level: level)
            }
            
            print("\(levelsBold)")
        }))
        
//        _ = [LevelOfMasteryEntity(type: .apprentice,
//                                  isLock: false,
//                                  progress: 75,
//                                  params: [CheckLevelEntity(checkPoint: true, titleText: "400 of 500 points", points: 500)
//                ]),
//            LevelOfMasteryEntity(type: .risingPower,
//                                 isLock: true,
//                                 progress: 0,
//                                 params: [CheckLevelEntity(checkPoint: true, titleText: "300 points", points: 300),
//                                          CheckLevelEntity(checkPoint: true, titleText: "1 mid-term goal achieved", points: nil),
//                ]),
//            LevelOfMasteryEntity(type: .intermidiate,
//                                 isLock: true,
//                                 progress: 0,
//                                 params: [CheckLevelEntity(checkPoint: true, titleText: "600 points", points: 600),
//                                          CheckLevelEntity(checkPoint: true, titleText: "3 mid-term goals", points: nil),
//                ]),
//            LevelOfMasteryEntity(type: .seasoned,
//                                 isLock: true,
//                                 progress: 0,
//                                 params: [CheckLevelEntity(checkPoint: true, titleText: "Min 1000 points", points: 1000),
//                                          CheckLevelEntity(checkPoint: true, titleText: "1 long-term and 5 mid-term achieved. Or 2 long-term goals achieved", points: nil),
//                ]),
//            LevelOfMasteryEntity(type: .unstoppable,
//                                 isLock: true,
//                                 progress: 0,
//                                 params: [CheckLevelEntity(checkPoint: true, titleText: "2000 points", points: 2000),
//                                          CheckLevelEntity(checkPoint: true, titleText: "3 long-term and 1 long-term goals achieved and 7 mid-term achieved", points: nil),
//                ])]
    }
    
    func createLevelEntity(level: LevelBold) -> LevelOfMasteryEntity {

        return LevelOfMasteryEntity(type: level.type,
                                    isLock: StatusLevelsType.disable == level.status,
                                    progress: level.completionPercentage,
                                    params: createCheckLimitLevel(limitsLevel: level.limits))
    }
    
    func createCheckLimitLevel(limitsLevel: [LimitsLevel]) -> [CheckLevelEntity] {
        
        let limits = limitsLevel.compactMap { (limit) -> CheckLevelEntity in
            
            return CheckLevelEntity(checkPoint: true, titleText: "400 of 500 points", points: 500)
        }
        
        
//        if limitLevel.goalLong == 0 && limitLevel.goalMid == 0 {
//            return [CheckLevelEntity(checkPoint: true, titleText: "400 of 500 points", points: 500)]
//        }
        
        return limits
        
    }
    
}
