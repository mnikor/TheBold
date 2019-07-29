//
//  CalendarActionsListPresenter.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/23/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation

enum CalendarActionsListInputPresenter {
    case createAction
    case editAction(ActEntity)
    case calendarHeader
    case longTapAction
}

protocol CalendarActionsListInputPresenterProtocol {
    func input(_ inputCase: CalendarActionsListInputPresenter)
}

class CalendarActionsListPresenter: PresenterProtocol, CalendarActionsListInputPresenterProtocol {
    
    typealias View = CalendarActionsListViewController
    typealias Interactor = CalendarActionsListInteractor
    typealias Router = CalendarActionsListRouter
    
    weak var viewController: View!
    var interactor: Interactor!
    var router: Router!
    
    lazy var actItems : [ActEntity] = {
        return [ActEntity(type: .stake, items: nil, selected: false),
                ActEntity(type: .stake, items: nil, selected: false),
                ActEntity(type: .stake, items: nil, selected: false),
                ActEntity(type: .stake, items: nil, selected: false)]
    }()
    
    required init(view: View) {
        self.viewController = view
    }
    
    required init?(coder aDecoder: NSCoder) {
    }
    
    func input(_ inputCase: CalendarActionsListInputPresenter) {
        switch inputCase {
        case .createAction:
            router.input(.presentdCreateAction)
        case .editAction(let entity):
            let editVC = EditActionPlanViewController.createController {
                print("create")
            }
            router.input(.editAction(editVC))
        case .calendarHeader:
            print("calendar")
        case .longTapAction:
            print("longTapAction")
        }
        
        
    }
}
