//
//  ActPresenter.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/22/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation

enum ActPresenterInput {
    case showMenu
    case calendar
    case tapPlus
    case allGoals
    case goalItem
    case longTapAction
}

protocol ActPresenterInputProtocol {
    func input(_ inputCase: ActPresenterInput)
}

class ActPresenter: PresenterProtocol, ActPresenterInputProtocol {
    
    typealias View = ActViewController
    typealias Interactor = ActInteractor
    typealias Router = ActRouter
    
    weak var viewController: View!
    var interactor: Interactor!
    var router: Router!
    
    required init(view: View) {
        self.viewController = view
    }
    
    required init?(coder aDecoder: NSCoder) {
        
    }
    
    lazy var actItems : [ActEntity] = {
        return [ActEntity(type: .goals, items: [1, 2, 3, 4], selected: false),
                ActEntity(type: .stake, items: nil, selected: false),
                ActEntity(type: .stake, items: nil, selected: false),
                ActEntity(type: .stake, items: nil, selected: false),
                ActEntity(type: .stake, items: nil, selected: false)]
    }()
    
    func input(_ inputCase: ActPresenterInput) {
        switch inputCase {
        case .showMenu:
            router.input(.menuShow)
        case .calendar:
            router.input(.calendar)
        case .tapPlus:
            router.input(.tapPlus)
        case .allGoals:
            router.input(.allGoals)
        case .goalItem:
            router.input(.goalItem)
        case .longTapAction:
            let vc = StartActionViewController.createController {
                print("Start")
            }
            router.input(.longTapActionPresentedBy(vc))
        }
    }
    
}

struct ActEntity {
    var type: ActCellType
    var items: Array<Any>?
    var selected: Bool
}
