//
//  LevelOfMasteryPresenter.swift
//  Bold
//
//  Created by Alexander Kovalov on 8/27/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation
import UIKit

enum LevelOfMasteryPresenterInput {
    case close
    case createDataSource
}

protocol LevelOfMasteryInputProtocol: PresenterProtocol {
    func input(_ inputCase: LevelOfMasteryPresenterInput)
}

class LevelOfMasteryPresenter: LevelOfMasteryInputProtocol {
    
    typealias View = LevelOfMasteryViewController
    typealias Interactor = LevelOfMasteryInteractor
    typealias Router = LevelOfMasteryRouter
    
    weak var viewController: View!
    var interactor: Interactor!
    var router: Router!
    
    lazy var levels: [LevelOfMasteryEntity] = {
        
        return [LevelOfMasteryEntity(type: .apprentice,
                              isLock: false,
                              progress: 75,
                              params: [CheckLevelEntity(checkPoint: true, titleText: "400 of 500 points", points: 500)
            ]),
        LevelOfMasteryEntity(type: .risingPower,
                             isLock: true,
                             progress: 0,
                             params: [CheckLevelEntity(checkPoint: true, titleText: "300 points", points: 300),
                                      CheckLevelEntity(checkPoint: true, titleText: "1 mid-term goal achieved", points: nil),
            ]),
        LevelOfMasteryEntity(type: .intermidiate,
                             isLock: true,
                             progress: 0,
                             params: [CheckLevelEntity(checkPoint: true, titleText: "600 points", points: 600),
                                      CheckLevelEntity(checkPoint: true, titleText: "3 mid-term goals", points: nil),
            ]),
        LevelOfMasteryEntity(type: .seasoned,
                             isLock: true,
                             progress: 0,
                             params: [CheckLevelEntity(checkPoint: true, titleText: "Min 1000 points", points: 1000),
                                      CheckLevelEntity(checkPoint: true, titleText: "1 long-term and 5 mid-term achieved. Or 2 long-term goals achieved", points: nil),
            ]),
        LevelOfMasteryEntity(type: .unstoppable,
                             isLock: true,
                             progress: 0,
                             params: [CheckLevelEntity(checkPoint: true, titleText: "2000 points", points: 2000),
                                      CheckLevelEntity(checkPoint: true, titleText: "3 long-term and 1 long-term goals achieved and 7 mid-term achieved", points: nil),
            ])]
    }()
    
    required init?(coder aDecoder: NSCoder) {
        
    }
    
    required init(view: View) {
        self.viewController = view
    }
    
    func input(_ inputCase: LevelOfMasteryPresenterInput) {
        switch inputCase {
        case .close:
            router.input(.close)
        case .createDataSource:
            interactor.input(.createDataSource(completed: { (levelsMastery) in
                self.levels = levelsMastery
            }))
        }
    }
    
    
    
    
    
    
}

