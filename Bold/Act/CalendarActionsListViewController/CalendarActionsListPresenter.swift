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
    case calendarHeader(ActHeaderType)
    case longTapAction
    case yearMonthAlert
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
    
    var currentDate = Date()
    var isCalendar : Bool = false
    
    lazy var calendarItems : [ActEntity] = {
        return [ActEntity(type: .calendar, items: nil, selected: false)]
    }()
    
    lazy var actItems : [ActEntity] = {
        return [ActEntity(type: .stake, items: nil, selected: false),
                ActEntity(type: .stake, items: nil, selected: false),
                ActEntity(type: .stake, items: nil, selected: false),
                ActEntity(type: .stake, items: nil, selected: false)]
    }()
    
    lazy var actHeaders : [CalendarEntity] = {
        return [CalendarEntity(headerType: .calendar, items: actItems)]
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
        case .calendarHeader(let headerType):
            showHeaderCalendar(headerType)
        case .longTapAction:
            print("longTapAction")
        case .yearMonthAlert:
            let vc = YearMonthAlertViewController.createController(currentDate: currentDate) { [weak self] (selectDate) in
                self?.currentDate = selectDate
                self?.viewController.tableView.reloadData()
            }
            router.input(.yearMonthAlert(vc))
        }
        
    }
    
    func showHeaderCalendar(_ headerType: ActHeaderType) {
        print("calendar")
        
        if headerType == .calendar {
            let firstElem = actHeaders.first
            firstElem?.headerType = .none
            actHeaders.insert(CalendarEntity(headerType: .list, items: calendarItems), at: 0)
            viewController.tableView.reloadData()
        } else if headerType == .list {
            actHeaders.removeFirst()
            let firstElem = actHeaders.first
            firstElem?.headerType = .calendar
            viewController.tableView.reloadData()
        }
    }
}


class CalendarEntity {
    var headerType: ActHeaderType
    var items: Array<ActEntity>
    
    init(headerType: ActHeaderType, items: Array<ActEntity>) {
        self.headerType = headerType
        self.items = items
    }
}
