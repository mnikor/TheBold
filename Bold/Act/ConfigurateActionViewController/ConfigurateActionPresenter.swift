//
//  ConfigurateActionPresenter.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/24/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation

enum ConfigurateActionInputPresenter {
    case cancel
    case searchAction(AddActionCellType, String)
    
    case updateDataSource
    
    case selectBodyType(ConfigureActionType.BodyType, Int)
    case selectDaysRepeat([DaysOfWeekType])
    case selectGoal(Int)
    
    case showChooseStartDateSheet
    case showChooseEndDateSheet
    case showChooseTimeSheet
}

protocol ConfigurateActionInputPresenterProtocol {
    func input(_ inputCase: ConfigurateActionInputPresenter)
}

class ConfigurateActionPresenter: PresenterProtocol, ConfigurateActionInputPresenterProtocol {
    
    typealias View = ConfigurateActionViewController
    typealias Interactor = ConfigurateActionInteractor
    typealias Router = ConfigurateActionRouter
    
    weak var viewController: View!
    var interactor: Interactor!
    var router: Router!

    var action : Action!
    var goalID : String!
    var goalList : [Goal]!
    var goalsShortList : [GoalNameAndId]!
    var selectDays = [DaysOfWeekType]()
    
    var dataSourceType: AddActionCellType = .none
    var dataSource = [ConfigurateActionSectionModel]() {
        didSet {
            viewController.tableView.reloadData()
        }
    }
    
    required init(view: View) {
        self.viewController = view
    }
    
    required init?(coder aDecoder: NSCoder) {
    }
    
    func input(_ inputCase: ConfigurateActionInputPresenter) {
        switch inputCase {
        case .searchAction(let type, let actionID):
            dataSourceType = type
            interactor.input(.searchAction(actionID, {[weak self] (action) in
                self?.action = action
                self?.typeDataSource()
            }))
        case .updateDataSource:
            self.typeDataSource()
        case .cancel:
            router.input(.cancel)
        case .selectBodyType(let bodyCellType, let index):
            selectBodyType(cellType: bodyCellType, index: index)
        case .showChooseStartDateSheet:
            showDateSheet(type: .startDate)
        case .showChooseEndDateSheet:
            showDateSheet(type: .endDate)
        case .showChooseTimeSheet:
            showDateSheet(type: .time)
        case .selectDaysRepeat(let daysOfWeekRepeat):
            selectDayOfWeek(daysOfWeekRepeat: daysOfWeekRepeat)
        default:
            return
        }
    }
    
    func selectDayOfWeek(daysOfWeekRepeat: [DaysOfWeekType]) {
 
        allDaysOfWeek(isOn: false, updateDataSource: false)
        
        if daysOfWeekRepeat.count == 0 || daysOfWeekRepeat.count == 7 {
            action.repeatAction?.monday = true
            action.repeatAction?.wednesday = true
            action.repeatAction?.friday = true
        }else {
            for dayRepeat in daysOfWeekRepeat {
                
                switch dayRepeat {
                case .monday:
                    action.repeatAction?.monday = true
                case .tuesday:
                    action.repeatAction?.tuesday = true
                case .wednesday:
                    action.repeatAction?.wednesday = true
                case .thursday:
                    action.repeatAction?.thursday = true
                case .friday:
                    action.repeatAction?.friday = true
                case .saturday:
                    action.repeatAction?.saturday = true
                case .sunday:
                    action.repeatAction?.sunday = true
                }
                
            }
        }
        typeDataSource()
    }
    
    func selectBodyType(cellType: ConfigureActionType.BodyType, index: Int) {
        switch cellType {
        case .today:
            action.startDate = Date().baseTime() as NSDate
            typeDataSource()
        case .tommorowStartDate:
            let date = Date()
            action.startDate = date.tommorowDay() as NSDate
            typeDataSource()
        case .tommorowEndDate:
            let startDate = action.startDate! as Date
            action.endDate = startDate.tommorowDay() as NSDate
            typeDataSource()
        case .afterOneWeek:
            let startDate = action.startDate! as Date
            action.endDate = startDate.afterOneWeek() as NSDate
            typeDataSource()
        case .noRepeat:
            allDaysOfWeek(isOn: false, updateDataSource: true)
        case .everyDay:
            allDaysOfWeek(isOn: true, updateDataSource: true)
        case .daysOfWeek:
            selectDayOfWeek(daysOfWeekRepeat: [])
        case .chooseStartDate:
            showDateSheet(type: .startDate)
        case .chooseEndDate:
            showDateSheet(type: .endDate)
        
        
        case .noReminders:
            action.reminderMe?.isSetTime = false
            action.reminderMe?.timeInterval = 0
            action.reminderMe?.type = RemindMeType.noReminders.rawValue
            typeDataSource()
        case .beforeTheDay:
            action.reminderMe?.type = RemindMeType.beforeTheDay.rawValue
            if action.reminderMe?.isSetTime == false {
                action.reminderMe?.timeInterval = 12 * 3600
            }
            typeDataSource()
        case .onTheDay:
            action.reminderMe?.type = RemindMeType.onTheDay.rawValue
            if action.reminderMe?.isSetTime == false {
                action.reminderMe?.timeInterval = 12 * 3600
            }
            typeDataSource()
        case .setTime:
            if action.reminderMe?.type == RemindMeType.noReminders.rawValue {
                return
            }
            showDateSheet(type: .time)
            
        case .goalName:
            updateSelectGoal(index: index)
        case .goalNameSelect:
            return
            
        default:
            break
        }
        
    }
    
    func updateSelectGoal(index: Int) {
        
        var calculateIndex = index
        let goalSection = dataSource.first
        let headerGoal = goalSection?.items.first
        
        if let type = headerGoal?.type, case .header(_) = type {
            calculateIndex = calculateIndex - 1
        }

        action.goal = goalList[calculateIndex]
        typeDataSource()
    }
    
    func allDaysOfWeek(isOn: Bool, updateDataSource: Bool) {
        let daysOfWeek = action.repeatAction
        daysOfWeek?.monday = isOn
        daysOfWeek?.tuesday = isOn
        daysOfWeek?.wednesday = isOn
        daysOfWeek?.thursday = isOn
        daysOfWeek?.friday = isOn
        daysOfWeek?.saturday = isOn
        daysOfWeek?.sunday = isOn
        
        if updateDataSource == true {
            typeDataSource()
        }
    }
    
    func showDateSheet(type: DateAlertType) {
        
        guard let action = action else {return}
        
        
        let startDate : Date? = action.goal?.startDate as Date?
        var currentDate : Date = Date()
        let endDate : Date? = action.goal?.endDate as Date?
        
        switch type {
        case .startDate:
            //startDate = nil
            currentDate = action.startDate! as Date
            //endDate = nil
        case .endDate:
            //startDate = nil
            currentDate = action.endDate! as Date
            //endDate = nil
        case .time:
            guard let timeInterval = action.reminderMe?.timeInterval else { return }
            var reminder = Int(timeInterval)
            if action.reminderMe?.isSetTime == false {
                reminder = 12 * 3600
            }
            currentDate = Date().convertIntToDate(time: reminder)
        }
        
        let alertVC = DateAlertViewController.createController(type: type, currentDate: currentDate, startDate: startDate, endDate: endDate) { [weak self] (date) in
            
            switch type {
            case .startDate:
                self?.action.startDate = date as NSDate
            case .endDate:
                self?.action.endDate = date as NSDate
            case .time:
                self?.action.reminderMe?.isSetTime = true
                self?.action.reminderMe?.timeInterval = Int32(date.convertDateToInt())
            }
            
            self?.typeDataSource()
        }
        router.input(.presentSheet(alertVC))
        
    }
    
    func searchAction(actionID: String) {
        interactor.input(.searchAction(actionID, {[weak self] (actionFind) in
            if let action = actionFind {
                self?.action = action
            }
        }))
    }
    
    func typeDataSource() {
        
        switch dataSourceType {
        case .duration, .when:
            interactor.input(.createWhenDataSource({ [weak self] whenDataSource in
                self?.dataSource = whenDataSource
            }))
        case .reminder:
            interactor.input(.createRemindMeDataSource({ [weak self] remindDataSource in
                self?.dataSource = remindDataSource
            }))
        case .goal:
            interactor.input(.createGoalDataSource({ [weak self] goalDataSource in
                self?.dataSource = goalDataSource
            }))
        default:
            return
        }
        
    }
}
