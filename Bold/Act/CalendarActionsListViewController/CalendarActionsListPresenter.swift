//
//  CalendarActionsListPresenter.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/23/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation

enum CalendarActionsListInputPresenter {
    case createDataSource(goalID: String)
    
    case uploadNewEventsInDataSourceWhenScroll(Int)
    case scrollToMonthInCalendar(Date)
    
    case selectCalendarSection(date: Date)
    
    case createAction
    case editAction(ActEntity)
    case editActionNew(CalendarModelType)
    case calendarHeader(ActHeaderType)
    case longTapAction
    case yearMonthAlert(date: Date)
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
    
    var currentDate : Date! {
        didSet(newValue) {
            print("newValue = \(String(describing: newValue))")
        }
    }
    
    var goalID : String?
    
    var calendarDataSource = Set<Date>()
    var dataSourceModel = [StakeActionViewModel]()
    var dataSource = [CalendarActionSectionModel]()
    var baseDataSource = [CalendarActionSectionModel]()
    var calendarSection: CalendarActionSectionModel!
    var rangeDate: RangeDatePeriod!
    var goal: Goal!
    var isCalendarVisible: Bool = false
    
    var isLoadContent: Bool = false
    
    required init(view: View) {
        self.viewController = view
    }
    
    required init?(coder aDecoder: NSCoder) {
    }
    
    func input(_ inputCase: CalendarActionsListInputPresenter) {
        
        switch inputCase {
        case .createDataSource(goalID: let goalID):
            createDataSource(goalID: goalID)
        case .uploadNewEventsInDataSourceWhenScroll(let count):
            uploadNewEventInDataSource(count: count)
        case .selectCalendarSection(date: let date):
            configDataSource(date: date)
        case .scrollToMonthInCalendar(let date):
            checkingMonthWhenScroll(date: date)
        case .createAction:
            router.input(.presentdCreateAction(goalID: goal.id!))
        case .editAction(let entity):
            let editVC = EditActionPlanViewController.createController {
                print("create")
            }
            router.input(.editAction(editVC))
        case .editActionNew(let event):
            print("\(event)")
        case .calendarHeader(let headerType):
            showHeaderCalendar(headerType)
        case .longTapAction:
            print("longTapAction")
        case .yearMonthAlert(date: let date):
            let vc = YearMonthAlertViewController.createController(currentDate: date) { [weak self] (selectDate) in
                self?.currentDate = selectDate
                self?.checkedMonthWhenNewMonth(date: selectDate)
            }
            router.input(.yearMonthAlert(vc))
        }
        
    }
    
    private func createDataSource(goalID: String) {
        baseDataSource.removeAll()
        calendarDataSource.removeAll()
        dataSourceModel.removeAll()
        currentDate = Date()
        rangeDate = RangeDatePeriod.initRange(date: Date())
        self.goalID = goalID
        interactor.input(.createDataSource(goalID: goalID, startDate: rangeDate.start, endDate:rangeDate.end, success: { [weak self] dataSections in
            self?.baseDataSource += dataSections
            self?.configDataSource(date: nil)
        }))
    }
    
    private func uploadNewEventInDataSource(count: Int) {
        if isLoadContent == false, count >= dataSource.count - 10, dataSource.isEmpty == false, isCalendarVisible == false {
            isLoadContent = true
            self.rangeDate = rangeDate.addOneMonthToRange()
            interactor.input(.createDataSource(goalID: goalID!, startDate: rangeDate.start, endDate:rangeDate.end, success: { [weak self] dataSections in
                self?.baseDataSource += dataSections
                self?.configDataSource(date: nil)
            }))
        }
    }
    
    private func  configDataSource(date: Date?) {
        
        dataSource.removeAll()
        if isCalendarVisible == true {
            calendarSection.items.removeAll()
            calendarSection.items.append(CalendarActionItemModel(type: .calendar, modelView: .calendar(dates: calendarDataSource)))
            if let newDate = date {
                
                let search = baseDataSource.filter { (sectionModel) -> Bool in
                    return sectionModel.section.date.dayOfMonthOfYear() == newDate.dayOfMonthOfYear()
                }
                dataSource = [calendarSection]
                dataSource += search
            }else {
                dataSource = [calendarSection]
            }
        }else {
            dataSource = baseDataSource
        }
        DispatchQueue.main.async {
            self.viewController.tableView.reloadData()
            self.isLoadContent = false
        }
    }
    
    private func checkingMonthWhenScroll(date: Date) {
        checkedMonthWhenNewMonth(date: date, isNewRequestDataSource: false)
    }
    
    private func checkedMonthWhenNewMonth(date: Date, isNewRequestDataSource: Bool = true) {
        let search = baseDataSource.filter { (sectionModel) -> Bool in
            return sectionModel.section.date.monthOfYear() == date.monthOfYear()
        }
        if search.isEmpty {
            self.rangeDate = RangeDatePeriod.initRange(date: date)
            interactor.input(.createDataSource(goalID: goalID!, startDate: rangeDate.start, endDate:rangeDate.end, success: { [weak self] dataSections in
                self?.baseDataSource += dataSections
                self?.configDataSource(date: nil)
            }))
        }else if isNewRequestDataSource {
            configDataSource(date: date)
        }
    }
    
    private func showHeaderCalendar(_ headerType: ActHeaderType) {

        if headerType == .calendar {
            isCalendarVisible = true
            let firstElem = baseDataSource.first
            firstElem?.section.type = ActHeaderType.none
            firstElem?.section.rightButtonIsHidden = true
        } else if headerType == .list {
            isCalendarVisible = false
            let firstElem = baseDataSource.first
            firstElem?.section.type = ActHeaderType.calendar
            firstElem?.section.rightButtonIsHidden = false
            input(.createDataSource(goalID: self.goal.id!))
        }
        configDataSource(date: nil)
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
