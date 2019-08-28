//
//  CalendarAndHistoryPresenter.swift
//  Bold
//
//  Created by Admin on 8/16/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation

enum CalendarAndHistoryInputPresenter {
    case editAction(ActEntity)
    case longTapAction
    case yearMonthAlert
}

protocol CalendarAndHistoryInputPresenterProtocol {
    func input(_ inputCase: CalendarAndHistoryInputPresenter)
}

class CalendarAndHistoryPresenter: PresenterProtocol, CalendarAndHistoryInputPresenterProtocol {
    
    typealias View = CalendarAndHistoryViewController
    typealias Interactor = CalendarAndHistoryInteractor
    typealias Router = CalendarAndHistoryRouter
    
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
        return [CalendarEntity(headerType: .list, items: calendarItems),
                CalendarEntity(headerType: .calendar, items: actItems)]
    }()
    
    required init(view: View) {
        self.viewController = view
    }
    
    required init?(coder aDecoder: NSCoder) {
    }
    
    func input(_ inputCase: CalendarAndHistoryInputPresenter) {
        switch inputCase {
        case .editAction(let entity):
            let editVC = EditActionPlanViewController.createController {
                print("create")
            }
            router.input(.editAction(editVC))
        case .longTapAction:
            print("longTapAction")
        case .yearMonthAlert:
            let vc = YearMonthAlertViewController.createController(currentDate: currentDate) { [weak self] (selectDate) in
                self?.currentDate = selectDate
                self?.viewController?.tableView.reloadData()
            }
            router.input(.yearMonthAlert(vc))
        }
        
    }
    
}
