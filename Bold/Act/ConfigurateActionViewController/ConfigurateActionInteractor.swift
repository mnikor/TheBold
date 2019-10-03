//
//  ConfigurateActionInteractor.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/24/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation

enum ConfigurateActionInputInteractor {
    case searchAction(String, (Action?)->Void)
    case deleteAction(Action, ()->Void)
    case createWhenDataSource(([ConfigurateActionSectionModel])->Void)
    case createRemindMeDataSource(([ConfigurateActionSectionModel])->Void)
    case createGoalDataSource(([ConfigurateActionSectionModel])->Void)
    
    case updateRepeatDays([DaysOfWeekType])
    
    case updateStartDate
    case updateEndDate
    case updateRepeat
    case updateReminder
    case updateGoal
}

protocol ConfigurateActionInputInteractorProtocol: InteractorProtocol {
    func input(_ inputCase: ConfigurateActionInputInteractor)
}

class ConfigurateActionInteractor: ConfigurateActionInputInteractorProtocol {
    
    typealias Presenter = ConfigurateActionPresenter
    
    weak var presenter: Presenter!
    
    private var completeUpdate: ((Action?)->Void)?
    private var selectDays = [DaysOfWeekType]()
    
    required init(presenter: Presenter) {
        self.presenter = presenter
    }
    
    func input(_ inputCase: ConfigurateActionInputInteractor) {
        switch inputCase {
        case .searchAction(let actionID, let success):
            searchAction(actionID: actionID, success: success)
        case .createWhenDataSource(let success):
            updateDuration(success: success)
        case .createRemindMeDataSource(let success):
            updateReminder(success: success)
        case .createGoalDataSource(let success):
            updateGoal(success: success)
        case .updateRepeatDays(let daysOfWeekTypes):
            switch daysOfWeekTypes.count {
            case 0: print("sdf")
            case 7: print("fsdf")
            default: print("sdfsd")
            }
        case .deleteAction(let action, let success):
            deleteAction(action: action, success: success)
        default:
            print("")
        }
    }
    
    func deleteAction(action: Action, success: ()->Void) {
        DataSource.shared.backgroundContext.delete(action)
        DataSource.shared.saveBackgroundContext()
        success()
    }
    
    func searchAction(actionID: String, success:(Action?)->Void) {
        DataSource.shared.updateAction(actionID: actionID, success: success)
    }
    
    // MARK: - Create models
    
    func createHeaderModel(type: ConfigureActionType.HeaderType) -> ConfigurateActionCellModel {
        
        let cellModel = ConfigureActionModelType.header(type.titleText())
        return ConfigurateActionCellModel(type: ConfigureActionType.header(type), modelValue: cellModel)
    }
    
    func createBodyModel(type: ConfigureActionType.BodyType, selectedType: ConfigureActionType.BodyType, date: Date?) -> ConfigurateActionCellModel {
        
        var titleText : String!
        var valueText : String?
        let isSelected : Bool!
        let textColor : Color!
        
        titleText = type.titleText()
        
        if type == selectedType {
            switch type {
            case .chooseStartDate, .chooseEndDate:
                titleText = DateFormatter.formatting(type: .configureAction, date: date ?? Date())
                valueText = ""
                isSelected = true
                textColor = ColorName.typographyBlack100.color
            case .setTime:
                titleText = DateFormatter.formatting(type: .timeAction, date: date ?? Date())
                valueText = ""
                isSelected = true
                textColor = ColorName.typographyBlack100.color
            case .noRepeat, .everyDay, .daysOfWeek, .noReminders, .onTheDay, .beforeTheDay:
                valueText = ""
                isSelected = true
                textColor = ColorName.typographyBlack100.color
            default:
                valueText = DateFormatter.formatting(type: .configureAction, date: date ?? Date())
                isSelected = true
                textColor = ColorName.typographyBlack100.color
            }
        } else {
            valueText = ""
            isSelected = false
            textColor = ColorName.typographyBlack50.color
        }
        
        let cellModel = ConfigureActionModelType.body(title:titleText, value: valueText, accessory: type.accesoryIsHidden(), isSelected: isSelected, textColor: textColor)
        
        return ConfigurateActionCellModel(type: ConfigureActionType.body(type), modelValue: cellModel)
    }
    
    func createDaysOfWeekModel(selectDays: [DaysOfWeekType]) -> ConfigurateActionCellModel {
        
        let cellModel = ConfigureActionModelType.daysOfWeek(selectDays)
        return ConfigurateActionCellModel(type: ConfigureActionType.body(.week), modelValue: cellModel)
    }
    
    func createGoalModel(type: ConfigureActionType.BodyType, name: String?) -> ConfigurateActionCellModel {
        
        let isSelected : Bool!
        let textColor : Color!
        
        if type == .goalNameSelect {
            isSelected = true
            textColor = ColorName.typographyBlack100.color
        }else {
            isSelected = false
            textColor = ColorName.typographyBlack50.color
        }
        
        let cellModel = ConfigureActionModelType.body(title: name ?? "", value: nil, accessory: true, isSelected: isSelected, textColor: textColor)
        return ConfigurateActionCellModel(type: ConfigureActionType.body(type), modelValue: cellModel)
    }
    
    func createNewGoalModel(type: ConfigureActionType.BodyType) -> ConfigurateActionCellModel {
        let cellModel = ConfigureActionModelType.createNewGoal(placeholder: L10n.Act.Goals.enterYourGoal)
        return ConfigurateActionCellModel(type: ConfigureActionType.body(type), modelValue: cellModel)
    }
    // MARK: - Duration Data Source
    
    func calculateDayInDuration(startDate: Date, endDate: Date?) -> (date: Date, type: ConfigureActionType.BodyType) {
        
        let date = Date().baseTime()
        if let countStartDay = date.totalDistance(from: startDate, resultIn: .day), endDate == nil {
            
            switch countStartDay {
            case 0:
                return (startDate, .today)
            case 1:
                return (startDate, .tommorowStartDate)
            default :
                return (startDate, .chooseStartDate)
            }
        }
        
        let endDateBase = endDate ?? startDate
        
        if let countEndDay = startDate.totalDistance(from: endDateBase, resultIn: .day) {
            
            switch countEndDay {
            case 1:
                return (endDateBase, .tommorowEndDate)
            case 7:
                return (endDateBase, .afterOneWeek)
            default :
                return (endDateBase, .chooseEndDate)
            }
        }
        return (Date(), .none)
    }
    
    func checkSelectDayOfWeek(repeatDays: DaysOfWeek) {
        
        selectDays.removeAll()
        
        if repeatDays.monday == true {
            selectDays.append(.monday)
        }
        if repeatDays.tuesday == true {
            selectDays.append(.tuesday)
        }
        if repeatDays.wednesday == true {
            selectDays.append(.wednesday)
        }
        if repeatDays.thursday == true {
            selectDays.append(.thursday)
        }
        if repeatDays.friday == true {
            selectDays.append(.friday)
        }
        if repeatDays.saturday == true {
            selectDays.append(.saturday)
        }
        if repeatDays.sunday == true {
            selectDays.append(.sunday)
        }
    }
    
    func calculateRepeatInDuration(repeatDays: DaysOfWeek?) -> (ConfigureActionType.BodyType) {
        
        guard let repeatDays = repeatDays else { return .noRepeat }
        
        checkSelectDayOfWeek(repeatDays: repeatDays)
        
        switch selectDays.count {
        case 0:
            return (.noRepeat)
        case 7:
            return (.everyDay)
        default:
            return (.daysOfWeek)
        }
    }
    
    func updateDuration(success: ([ConfigurateActionSectionModel])->Void) {
        
        let startDateBase = presenter.action.startDate as Date? ?? Date()
        let endDateBase = presenter.action.endDate as Date? ?? Date().tommorowDay()
        let repeatDays = presenter.action.repeatAction
        
        let startDateResult = calculateDayInDuration(startDate: startDateBase, endDate: nil)
        let endDateResult = calculateDayInDuration(startDate: startDateBase, endDate: endDateBase)
        let repeatResult = calculateRepeatInDuration(repeatDays: repeatDays)
        
        let section = [
            ConfigurateActionSectionModel(type: .startDate, items:
                [
                    createHeaderModel(type: .startDate),
                    createBodyModel(type: .today, selectedType: startDateResult.type, date: startDateResult.date),
                    createBodyModel(type: .tommorowStartDate, selectedType: startDateResult.type, date: startDateResult.date),
                    createBodyModel(type: .chooseStartDate, selectedType: startDateResult.type, date: startDateResult.date)
                ]),
            ConfigurateActionSectionModel(type: .endDate, items:
                [
                    createHeaderModel(type: .endDate),
                    createBodyModel(type: .tommorowEndDate, selectedType: endDateResult.type, date: endDateResult.date),
                    createBodyModel(type: .afterOneWeek, selectedType: endDateResult.type, date: endDateResult.date),
                    createBodyModel(type: .chooseEndDate, selectedType: endDateResult.type, date: endDateResult.date)
                ]),
            ConfigurateActionSectionModel(type: .repeatAction, items:
                [
                    createHeaderModel(type: .repeatAction),
                    createBodyModel(type: .noRepeat, selectedType: repeatResult, date: nil),
                    createBodyModel(type: .everyDay, selectedType: repeatResult, date: nil),
                    createBodyModel(type: .daysOfWeek, selectedType: repeatResult, date: nil)
                ])
        ]
        
        if repeatResult == .daysOfWeek {
            let sectionModel = section.last
            sectionModel?.items.append(createDaysOfWeekModel(selectDays: selectDays))
        }
        
        success(section)
    }
    
    
    // MARK: - Reminders Data Source
    
    func calculateReminders(reminderValue: Int16?) -> (ConfigureActionType.BodyType) {
        
        guard let reminder = reminderValue else { return (.noReminders) }
        let reminderType = RemindMeType(rawValue:  reminder) ?? .noReminders
        
        switch reminderType {
        case .noReminders:
            return (.noReminders)
        case .onTheDay:
            return (.onTheDay)
        case .beforeTheDay:
            return (.beforeTheDay)
        }
    }
    
    func calculateWhenTime(reminder: Reminder?) -> (type: ConfigureActionType.BodyType, date: Date?) {
        if reminder?.isSetTime == true, let whenTime = reminder?.timeInterval, whenTime != 0 {
            return (type: .setTime, date: Date().convertIntToDate(time: Int(whenTime)))
        }else {
            return (type: .none, date: nil)
        }
    }
    
    func updateReminder(success: ([ConfigurateActionSectionModel])->Void) {
        let reminderResult = calculateReminders(reminderValue: presenter.action.reminderMe?.type)
        let whenTimeResult = calculateWhenTime(reminder: presenter.action.reminderMe)

        let section = [
            ConfigurateActionSectionModel(type: .remindMe, items:
                [
                    createHeaderModel(type: .remindMe),
                    createBodyModel(type: .noReminders, selectedType: reminderResult, date: nil),
                    createBodyModel(type: .beforeTheDay, selectedType: reminderResult, date: nil),
                    createBodyModel(type: .onTheDay, selectedType: reminderResult, date: nil)
                ]),
            ConfigurateActionSectionModel(type: .when, items:
                [
                    createHeaderModel(type: .when),
                    createBodyModel(type: .setTime, selectedType: whenTimeResult.type, date: whenTimeResult.date)
                ])
        ]
        
        success(section)
    }
    
    // MARK: - Goal Data Source
    
    func calculateGoal(goalID: String?, goals: [Goal]) -> [GoalNameAndId] {
        
        if goals.isEmpty {
            return ([])
        }

        var body = [GoalNameAndId]()
        var type : ConfigureActionType.BodyType = .none
        
        for goalItem in goals {
            if let goalIDTemp = goalID, goalIDTemp == goalItem.id {
                type = .goalNameSelect
            } else {
                type = .goalName
            }
            let bodyGoal = GoalNameAndId(type: type, goal: goalItem)
            body.append(bodyGoal)
        }
        return (body)
    }
    
    func updateGoal(success: ([ConfigurateActionSectionModel])->Void) {
        
        //if presenter.goalList == nil || presenter.goalList.isEmpty {
            presenter.goalList = DataSource.shared.goalsListForUpdate()
        //}
        
        var section = [
            ConfigurateActionSectionModel(type: .orCreateNew, items:
            [
                createHeaderModel(type: .orCreateNew),
                createNewGoalModel(type: .enterGoal)
            ])]

        guard let goalsList = presenter.goalList else {
            success(section)
            return
        }
        
        let goalResult = calculateGoal(goalID: presenter.action.goal?.id, goals: goalsList)
        
        if !goalResult.isEmpty {
            let sectionItem = ConfigurateActionSectionModel(type: .chooseGoal, items:
                [
                    createHeaderModel(type: .chooseGoal)
                ])
            
            for goalItem in goalResult {
                sectionItem.items.append(createGoalModel(type: goalItem.type, name: goalItem.goal?.name))
            }
            
            section.insert(sectionItem, at: 0)
        }
        success(section)
    }
}
