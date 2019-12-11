//
//  BaseStakesListInteractor.swift
//  Bold
//
//  Created by Alexander Kovalov on 19.11.2019.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation

enum BaseStakesListInputInteractor {
    case createDataSource(type: BaseStakesDataSourceType, goalID: String?, startDate: Date, endDate:Date, success:([ActDataSourceViewModel])->Void)
}

protocol BaseStakesListInputInteractorProtocol {
    func input(_ inputCase: BaseStakesListInputInteractor)
}

class BaseStakesListInteractor: InteractorProtocol, BaseStakesListInputInteractorProtocol {
    
    typealias Presenter = BaseStakesListPresenter
    
    weak var presenter: Presenter!
    
    required init(presenter: Presenter) {
        self.presenter = presenter
    }
    
    func input(_ inputCase: BaseStakesListInputInteractor) {
        switch inputCase {
            
        case .createDataSource(type: let type, goalID: let goalID, startDate: let startDate, endDate: let endDate, success: let success):
            createDifferentDataSource(type: type, goalID: goalID, startDate: startDate, endDate: endDate, success: success)
            //createDataSource(goalID:goalID, startDate: startDate, endDate:endDate, success: success)
        }
    }
    
    func createDifferentDataSource(type: BaseStakesDataSourceType, goalID: String?, startDate: Date, endDate: Date, success: ([ActDataSourceViewModel])->Void) {
        switch type {
        case .all:
            createDataSourceForAll(startDate: startDate, endDate:endDate, success: success)
        case .forGoal:
            createDataSourceForGoal(goalID: goalID, startDate: startDate, endDate: endDate, success: success)
        case .archive:
            createDataSourceForArchieve(startDate: startDate, endDate: endDate, success: success)
        }
    }
    
    func createDataSourceForGoal(goalID: String?, startDate: Date, endDate:Date, success: ([ActDataSourceViewModel])->Void) {
        
        createCalendarSection()
        
        DataSource.shared.searchEventsInGoal(goalID: goalID, startDate: startDate, endDate:endDate) { [weak self] (events) in
            
            let dataSource = events.compactMap { (event) -> StakeActionViewModel in
                
                //создаем набор сетов елементов для календаря
                if let startDate = event.startDate {
                    presenter.calendarDataSource.insert((startDate as Date).dayOfMonthOfYear())
                }
                
                //создаем view model эвентов
                return StakeActionViewModel.createModelView(event: event)
            }
            
            //создаем заголовки, сортируем и группируем их для евентов одного дня
            self?.createHeaders(viewModels: dataSource, completed: { (sectionStake) in
                
                let transformSection = sectionStake.compactMap { (calendarSection) -> ActDataSourceViewModel in
                    return ActDataSourceViewModel(section: ActSectionModelType.calendar(viewModel: calendarSection.section),
                            items: calendarSection.items)
                }
                
                if let todayActionEmpty = checkTodayActionEmpty(sectionStake: sectionStake) {
                    self?.presenter.dataSource.append(todayActionEmpty)
                }
                
                success(transformSection)
                
            })
        }
    }
    
    func createDataSourceForAll(startDate: Date, endDate:Date, success: ([ActDataSourceViewModel])->Void) {
        
        createCalendarSection()

        if case .all = presenter.type {
            createGoals()
        }
        
        DataSource.shared.searchEventsInAllGoals(firstRequest: true, startDate: startDate, endDate: endDate) { [weak self] (events) in
            
            let dataSource = events.compactMap { (event) -> StakeActionViewModel in
                
                //создаем набор сетов елементов для календаря
                if let startDate = event.startDate {
                    presenter.calendarDataSource.insert((startDate as Date).dayOfMonthOfYear())
                }
                
                //создаем view model эвентов
                return StakeActionViewModel.createModelView(event: event)
            }
            
            //создаем заголовки, сортируем и группируем их для евентов одного дня
            self?.createHeaders(viewModels: dataSource, completed: { (sectionStake) in
                
                let transformSection = sectionStake.compactMap { (calendarSection) -> ActDataSourceViewModel in
                    return ActDataSourceViewModel(section: ActSectionModelType.calendar(viewModel: calendarSection.section),
                            items: calendarSection.items)
                }
                
                if let todayActionEmpty = checkTodayActionEmpty(sectionStake: sectionStake) {
                    self?.presenter.dataSource.append(todayActionEmpty)
                }
                
                success(transformSection)
                
            })
        }
    }
    
    func createDataSourceForArchieve(startDate: Date, endDate:Date, success: ([ActDataSourceViewModel])->Void) {
        
        createCalendarSection()
        
        DataSource.shared.searchEventsInAllGoalsArchive(startDate: startDate, endDate: endDate) { [weak self] (events) in
            
            let dataSource = events.compactMap { (event) -> StakeActionViewModel in
                
                //создаем набор сетов елементов для календаря
                if let startDate = event.startDate {
                    presenter.calendarDataSource.insert((startDate as Date).dayOfMonthOfYear())
                }
                
                //создаем view model эвентов
                return StakeActionViewModel.createModelView(event: event)
            }
            
            //создаем заголовки, сортируем и группируем их для евентов одного дня
            self?.createHeaders(viewModels: dataSource, completed: { (sectionStake) in
                
                let transformSection = sectionStake.compactMap { (calendarSection) -> ActDataSourceViewModel in
                    return ActDataSourceViewModel(section: ActSectionModelType.calendar(viewModel: calendarSection.section),
                            items: calendarSection.items)
                }
                
                if let todayActionEmpty = checkTodayActionEmpty(sectionStake: sectionStake) {
                    self?.presenter.dataSource.append(todayActionEmpty)
                }
                
                success(transformSection)
                
            })
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
                
                switch presenter.type {
                case .forGoal:
                    type = .calendar
                    title = L10n.Act.todaysActions
                    subtitle = L10n.Act.youHaveActionWithStakes("\(items.count)")
                case .all:
                    type = .plus
                    title = L10n.Act.todaysActions
                    subtitle = L10n.Act.youHaveActionWithStakes("\(items.count)")
                case .archive:
                    type = .none
                    title = key.dayOfWeek()
                    subtitle = DateFormatter.formatting(type: .headerSomeDayEvent, date: key)
                case .none:
                    type = .none
                }
//                title = L10n.Act.todaysActions
//                subtitle = L10n.Act.youHaveActionWithStakes("\(items.count)")
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
    
    func createCalendarSection() {
        let currentDate = Date().dayOfMonthOfYear()
        let tommorowDate = Date().tommorowDay().dayOfMonthOfYear()
        
        DataSource.shared.searchEventsInGoal(goalID: presenter.goalID, startDate: currentDate, endDate: tommorowDate) { (events) in
            
            let calendarType = ActHeaderType.list
            let calendarTitle = L10n.Act.actionPlan
            let calendarSubtitle = L10n.Act.youHaveActionWithStakes("\(events.count)")
            let calendarSection = CalendarActionSectionViewModel(type: calendarType, date: currentDate, title: calendarTitle, subtitle: calendarSubtitle, backgroundColor: ColorName.tableViewBackground.color, imageButton: calendarType.imageInButton(), rightButtonIsHidden: calendarType.isHiddenRightButton())
            let calendarModelSet = CalendarModelType.calendar(dates: presenter.calendarDataSource)
            let type = (presenter.type == .archive) ? ActSectionModelType.goal : .calendar(viewModel: calendarSection)
            self.presenter.calendarSection = ActDataSourceViewModel(section: type, items: [calendarModelSet])
        }
    }
    
    func createGoals() {
        
        loadGoals {[weak self] (goalSection) in
            
            let item = CalendarModelType.goals(viewModel: goalSection)
            let goalSection = ActDataSourceViewModel(section: ActSectionModelType.goal,
                                                items: [item])
            
            self?.presenter.goalSection = goalSection
            //self?.presenter.dataSource = [goalSection]
        }
    }
    
    private func loadGoals(success: (ActivityViewModel)->Void) {
        
        let currentDate = Date().dayOfMonthOfYear()
        let tommorowDate = Date().tommorowDay().dayOfMonthOfYear()
        
        DataSource.shared.goalsListForRead { (goals) in

            let dataSource = goals.compactMap { (goal) -> GoalCollectionViewModel in
                return GoalCollectionViewModel.createGoalModel(goal: goal)
            }
            
            DataSource.shared.searchEventsInGoal(goalID: nil, startDate: currentDate, endDate: tommorowDate) { (events) in
                
                success(createGoalsSection(goals: dataSource, itemsCount: events.count))
            }
        }
    }
    
    private func createGoalsSection(goals: [GoalCollectionViewModel], itemsCount: Int) -> ActivityViewModel {
        
        let activityModel = ActivityViewModel.createViewModel(type: .activeGoalsAct, goals: goals, content: [], itemCount: itemsCount)
        return activityModel
    }
    
    private func checkTodayActionEmpty(sectionStake: [CalendarActionSectionModel]) -> ActDataSourceViewModel? {
        
        if presenter.dataSource.count == 0 {
            
            let todayEvents = sectionStake.filter { (calendarSection) -> Bool in
                return calendarSection.section.date.dayOfMonthOfYear() == Date().dayOfMonthOfYear()
            }
            
            if todayEvents.isEmpty {
                let emptyTodaySection = createTodaysActionEmpty()
                let emptyCalendarSection = ActDataSourceViewModel(section: ActSectionModelType.calendar(viewModel: emptyTodaySection.section),
                items: emptyTodaySection.items)
                //presenter.dataSource.append(emptyCalendarSection)
                
                return emptyCalendarSection
            }
        }
        
        return nil
    }
    
    private func createTodaysActionEmpty() -> CalendarActionSectionModel {
        
        let type : ActHeaderType = .plus
        let sectionEmpty = CalendarActionSectionViewModel(type: type, date: Date(), title: L10n.Act.todaysActions, subtitle: L10n.Act.seriouslyNoActions, backgroundColor: .white, imageButton: type.imageInButton(), rightButtonIsHidden: type.isHiddenRightButton())
        
        return CalendarActionSectionModel(section: sectionEmpty, items: [])
    }
    
    private func getCountTodayEvents() -> Int {
        
        return 0
    }
    
}
