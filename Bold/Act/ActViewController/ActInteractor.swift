//
//  ActInteractor.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/22/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation

enum ActInputInteractor {
    case searchGoals
    case searchEvents
//    case doneEvent(eventID: String?, success: ()->Void)
    
    case createDataSource(success: ()->Void)
    case createGoalsSection(success: ()->Void)
    case createStakesSection(success: ()->Void)
}

protocol ActInteractorProtocol {
    func input(_ inputCase:ActInputInteractor)
}

class ActInteractor: InteractorProtocol, ActInteractorProtocol {
    
    typealias Presenter = ActPresenter
    
    weak var presenter: Presenter!
    
    required init(presenter: Presenter) {
        self.presenter = presenter
    }
    
    var goals = [GoalCollectionViewModel]()
    
    func input(_ inputCase: ActInputInteractor) {
        switch inputCase {
        case .createDataSource(let success):
            createDataSource(success: success)
        case .searchGoals:
            print("sdasd")
        case .searchEvents:
            print("sdasd")
//        case .doneEvent(eventID: let eventID, success: let success):
//            doneEvent(eventID: eventID, success: success)
        case .createGoalsSection(success: let success):
            createGoalsSection(success: success)
        case .createStakesSection(success: let success):
            createStakesSection(success: success)
        }
    }
    
    private func createDataSource(success: ()->Void) {
        
        loadGoals {[weak self] (goalSection) in
            
            let item = CalendarModelType.goals(viewModel: goalSection)
            let goalSection = ActDataSourceItem(section: ActSectionModelType.goal,
                                                items: [item])
            self?.presenter.dataSource = [goalSection]
        }
        
        loadEvents {[weak self] (eventsList) in
            
            self?.createHeaders(viewModels: eventsList, completed: { (sectionStake) in
                
                let transformSection = sectionStake.compactMap { (calendarSection) -> ActDataSourceItem in
                    return (section: ActSectionModelType.calendar(viewModel: calendarSection.section),
                            items: calendarSection.items)
                }
                
                if let todayActionEmpty = checkTodayActionEmpty(sectionStake: sectionStake) {
                    self?.presenter.dataSource.append(todayActionEmpty)
                }
                
                self?.presenter.dataSourceModel += eventsList
                presenter.dataSource += transformSection
                success()
            })
        }
    }
    
//    private func updateDataSource(success:()->Void) {
//
//        loadGoals {[weak self] (goalSection) in
//
//            let item = CalendarActionItemModel(type: .goals, modelView: CalendarModelType.goals(viewModel: goalSection))
//            let goalSection = ActDataSourceItem(section: ActSectionModelType.goal,
//                                                items: [item])
//            self?.presenter.dataSource = [goalSection]
//        }
//
//        //loadEvents {[weak self] (eventsList) in
//
//        presenter.dataSourceModel.removeAll { (event) -> Bool in
//            if event.id =
//        }
//
//            self?.createHeaders(viewModels: eventsList, completed: { (sectionStake) in
//
//                let transformSection = sectionStake.compactMap { (calendarSection) -> ActDataSourceItem in
//                    return (section: ActSectionModelType.calendar(viewModel: calendarSection.section),
//                            items: calendarSection.items)
//                }
//
//                if let todayActionEmpty = checkTodayActionEmpty(sectionStake: sectionStake) {
//                    self?.presenter.dataSource.append(todayActionEmpty)
//                }
//
//                self?.presenter.dataSourceModel += eventsList
//                presenter.dataSource += transformSection
//                success()
//            //})
//        }
//    }
    
    private func createGoalsSection(success: ()->Void) {
        
        loadGoals {[weak self] (goalSection) in
            
            let item = CalendarModelType.goals(viewModel: goalSection)
            let goalSection = ActDataSourceItem(section: ActSectionModelType.goal,
                                                items: [item])
            self?.presenter.dataSource = [goalSection]
            success()
        }
    }
    
    private func createStakesSection(success: ()->Void) {
        
        loadEvents {[weak self] (eventsList) in
            
            self?.createHeaders(viewModels: eventsList, completed: { (sectionStake) in
                
                let transformSection = sectionStake.compactMap { (calendarSection) -> ActDataSourceItem in
                    return (section: ActSectionModelType.calendar(viewModel: calendarSection.section),
                            items: calendarSection.items)
                }
                
                if let todayActionEmpty = checkTodayActionEmpty(sectionStake: sectionStake) {
                    self?.presenter.dataSource.append(todayActionEmpty)
                }
                
                self?.presenter.dataSourceModel += eventsList
                presenter.dataSource += transformSection
                success()
            })
        }
    }
    
    private func loadGoals(success: (ActivityViewModel)->Void) {
        
        DataSource.shared.goalsListForRead { (goals) in
            //print("\(goals)")
            
            let dataSource = goals.compactMap { (goal) -> GoalCollectionViewModel in
                return GoalCollectionViewModel.createGoalModel(goal: goal)
            }
            //self?.goals = dataSource
            //print("\(dataSource)")
            
            success(createGoalsSection(goals: dataSource, itemsCount: 0))
        }
    }
    
    private func loadEvents(success: ([StakeActionViewModel])->Void) {
        
        DataSource.shared.searchEventsInGoals(startDate: Date().dayOfMonthOfYear(), offset:presenter.dataSourceModel.count) { (events) in
            //print("\(events)")
            
            let dataSource = events.compactMap { (event) -> StakeActionViewModel in
                return StakeActionViewModel.createModelView(event: event)
            }
            //self.presenter.dataSourceModel += dataSource
//            self?.createHeaders(viewModels: dataSource, completed: success)
            
            success(dataSource)
        }
        
    }
    
    private func createHeaders(viewModels: [StakeActionViewModel], completed:([CalendarActionSectionModel])->Void) {
        
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
                type = .plus
                title = L10n.Act.todaysActions
                subtitle = L10n.Act.youHaveActionWithStakes("\(items.count)")
                //self.presenter.goalsSection = createGoalsSection(goals: goals, itemsCount: items.count)
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
        
        //section.removeFirst()
        
        completed(section)
    }
    
    private func createGoalsSection(goals: [GoalCollectionViewModel], itemsCount: Int) -> ActivityViewModel {
        
        let activityModel = ActivityViewModel.createViewModel(type: .activeGoalsAct, goals: goals, content: [], itemCount: itemsCount)
        return activityModel
    }
    
    private func createTodaysActionEmpty() -> CalendarActionSectionModel {
        
        let type : ActHeaderType = .plus
        let sectionEmpty = CalendarActionSectionViewModel(type: type, date: Date(), title: L10n.Act.todaysActions, subtitle: L10n.Act.seriouslyNoActions, backgroundColor: .white, imageButton: type.imageInButton(), rightButtonIsHidden: type.isHiddenRightButton())
        
        return CalendarActionSectionModel(section: sectionEmpty, items: [])
    }
    
    private func checkTodayActionEmpty(sectionStake: [CalendarActionSectionModel]) -> ActDataSourceItem? {
        
        if presenter.dataSourceModel.count == 0 {
            
            let todayEvents = sectionStake.filter { (calendarSection) -> Bool in
                return calendarSection.section.date.dayOfMonthOfYear() == Date().dayOfMonthOfYear()
            }
            
            if todayEvents.isEmpty {
                let emptyTodaySection = createTodaysActionEmpty()
                let emptyCalendarSection = ActDataSourceItem(section: ActSectionModelType.calendar(viewModel: emptyTodaySection.section),
                items: emptyTodaySection.items)
                //presenter.dataSource.append(emptyCalendarSection)
                
                return emptyCalendarSection
            }
        }
        
        return nil
    }
    
}
