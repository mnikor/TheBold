//
//  CalendarActionsListInteractor.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/23/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation
import UIKit

enum CalendarActionsListInputInteractor {
    case createDataSource(goalID: String?, startDate: Date, endDate:Date, success:([CalendarActionSectionModel])->Void)
}

protocol CalendarActionsListInputInteractorProtocol {
    func input(_ inputCase: CalendarActionsListInputInteractor)
}

class CalendarActionsListInteractor: InteractorProtocol, CalendarActionsListInputInteractorProtocol {
    
    typealias Presenter = CalendarActionsListPresenter
    
    weak var presenter: Presenter!
    
    required init(presenter: Presenter) {
        self.presenter = presenter
    }
    
    func input(_ inputCase: CalendarActionsListInputInteractor) {
        switch inputCase {
            
        case .createDataSource(goalID: let goalID, startDate: let startDate, endDate: let endDate, success: let success):
            createDataSource(goalID:goalID, startDate: startDate, endDate:endDate, success: success)
        }
    }
    
    func createDataSource(goalID: String?, startDate: Date, endDate:Date, success: ([CalendarActionSectionModel])->Void) {
        
        DataSource.shared.searchEventsInGoal(goalID: goalID, startDate: startDate, endDate:endDate) { [weak self] (events) in
            let dataSource = events.compactMap { (event) -> StakeActionViewModel in
                
                if let startDate = event.startDate {
                    presenter.calendarDataSource.insert((startDate as Date).dayOfMonthOfYear())
                }
                return StakeActionViewModel.createModelView(event: event)
            }
            presenter.dataSourceModel += dataSource
            self?.createHeaders(viewModels: dataSource, completed: success)
        }
    }
    
    func createHeaders(viewModels: [StakeActionViewModel], completed:([CalendarActionSectionModel])->Void) {
        
        var section = [CalendarActionSectionModel]()
        let groupedItems = Dictionary(grouping: viewModels) { (eventViewModel) -> Date in
            return (eventViewModel.event.startDate! as Date).dayOfMonthOfYear()
        }
        section = groupedItems.map({ (arg) -> CalendarActionSectionModel in
            
            let (key, value) = arg
            let items = value.compactMap({ (itemViewModel) -> CalendarModelType in
                return CalendarModelType.event(viewModel: itemViewModel)
            })
            
            var type: ActHeaderType = .none
            var title: String?
            var subtitle: String?
            let backgroundColor: Color = .white
            
            if key.dayOfMonthOfYear() == Date().dayOfMonthOfYear() {
                type = .calendar
                title = L10n.Act.todaysActions
                subtitle = L10n.Act.youHaveActionWithStakes("\(items.count)")
                createCalendarSection(date: key, itemsCount: items.count)
            }else if key.dayOfMonthOfYear() == Date().tommorowDay().dayOfMonthOfYear() {
                title = L10n.Act.Duration.tommorow
                subtitle = DateFormatter.formatting(type: .select, date: key)
            }else {
                title = key.dayOfWeek()
                subtitle = DateFormatter.formatting(type: .headerSomeDayEvent, date: key)
            }
            
            let newSection = CalendarActionSectionViewModel(type: type, date: key, title: title, subtitle: subtitle, backgroundColor: backgroundColor, imageButton: type.imageInButton(), rightButtonIsHidden: type.isHiddenRightButton())
            
            return CalendarActionSectionModel(section: newSection, items: items)
        }).sorted()
        
        completed(section)
    }
    
    func createCalendarSection(date: Date, itemsCount: Int) {
        let calendarType = ActHeaderType.list
        let calendarTitle = L10n.Act.actionPlan
        let calendarSubtitle = L10n.Act.youHaveActionWithStakes("\(itemsCount)")
        let calendarSection = CalendarActionSectionViewModel(type: calendarType, date: date, title: calendarTitle, subtitle: calendarSubtitle, backgroundColor: ColorName.tableViewBackground.color, imageButton: calendarType.imageInButton(), rightButtonIsHidden: calendarType.isHiddenRightButton())
        presenter.calendarSection = CalendarActionSectionModel(section: calendarSection, items: [])
    }
}
