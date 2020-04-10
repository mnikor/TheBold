//
//  CreateActionInteractor.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/23/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation

enum CreateActionInputInteractor {
    case createNewAction(goalID: String?, contentID: String?, (CreateActionViewModel)->Void)
    case searchAction(actionID: String?, (CreateActionViewModel)->Void)
    case saveAction(()->Void)
    case saveActionWithContent(contentID: String?, completion: ()->Void)
    case updateAction(()->Void)
    
    case updateName(String)
    case updateConfiguration
    case updateStake(Float)
}

protocol CreateActionInputInteractorProtocol: InteractorProtocol {
    func input(_ inputCase: CreateActionInputInteractor)
}

class CreateActionInteractor: CreateActionInputInteractorProtocol {
    
    typealias Presenter = CreateActionPresenter
    
    weak var presenter: Presenter!
    
    private var completeUpdate: ((CreateActionViewModel)->Void)!
    
    required init(presenter: Presenter) {
        self.presenter = presenter
    }
    
    func input(_ inputCase: CreateActionInputInteractor) {
        switch inputCase {
        case .createNewAction(goalID: let goalID, contentID: let contentID, let complete):
            completeUpdate = complete
            createNewAction(goalID: goalID, contentID: contentID)
        case .searchAction(actionID: let actionID, let complete):
            completeUpdate = complete
            searchAction(actionID: actionID)
        case .saveAction(let complete):
            saveAction(complete)
        case .updateAction(let complete):
            updateAction(complete)
            
        case .updateName(let name):
            presenter.newAction.name = name
            createModelView(action: presenter.newAction)
        case .updateStake(let stake):
            presenter.newAction.stake = stake
            createModelView(action: presenter.newAction)
        case .updateConfiguration:
            createModelView(action: presenter.newAction)
        case .saveActionWithContent(contentID: let contentId, completion: let completion):
            saveAction(with: contentId, completion: completion)
        }
    }
    
    private func saveAction(_ complete:()->Void) {
        guard let _ = presenter.newAction  else { return }
        createEvents(action: presenter.newAction)
        DataSource.shared.saveBackgroundContext()
        complete()
    }
    
    private func saveAction(with contentId: String?, completion: @escaping ()->Void) {
//        guard let action = presenter.newAction  else { return }
//        if let contentIDTemp = contentId {
//            DataSource.shared.searchContent(contentID: contentIDTemp) { [weak self] (content) in
////                action.content = content
//                self?.createEvents(action: action)
//                DataSource.shared.saveBackgroundContext()
//                completion()
//            }
//        } else {
            saveAction(completion)
//        }
    }
    
    private func updateAction(_ complete:()->Void) {
        
        guard let actionID = presenter.updateAction.id else { return }
        
        DataSource.shared.listDeleteEvent(actionID: actionID, deleteDate: Date()) {[weak self] in
            self?.presenter.updateAction.status = StatusType.completeUpdate.rawValue
            self?.saveAction(complete)
        }
    }
    
    private func createEvents(action: Action) {
        
        var startDate = action.startDate! as Date
        let endDate = action.endDate! as Date
        
        switch presenter.baseConfigType {
        case .createNewActionVC:
            print("createNewActionVC")
        case .createNewActionSheet(contentID: _):
            print("createNewActionSheet(contentID: _)")
        case .editActionSheet(actionID: _):
            print("editActionSheet(actionID: _)")
            startDate = Date().baseTime()
        }
        
        let repeatDays = checkRepeatDayOfWeek(repeatDays: presenter.newAction.repeatAction)
        
        // Formatter for printing the date, adjust it according to your needs:
        //        let fmt = DateFormatter()
        //        fmt.dateFormat = "dd/MM/yyyy"
        
        if repeatDays.count > 0 {
            while startDate <= endDate {
                //                print(fmt.string(from: startDate))
                let calendar = Calendar.current
                if let daysWeek = DaysOfWeekType(rawValue: startDate.dayNumberOfWeek() ?? 0) {
                    if repeatDays.contains(daysWeek) {
                        //                        print("\(startDate.dayNumberOfWeek())")
                        //                        print("\(startDate.dayOfWeek())")
                        
                        let reminderDate = calculateReminder(startDate: startDate, reminderMe: presenter.newAction.reminderMe)
                        DataSource.shared.createEvent(action: action, startDate: startDate, endDate: endDate, reminderDate: reminderDate)
//                        NotificationService.shared.createReminder(title: <#T##String#>, body: <#T##String#>, date: <#T##Date#>, reminderType: <#T##ReminderType#>, identifier: <#T##String?#>)
                    }
                }
                startDate = calendar.date(byAdding: .day, value: 1, to: startDate)!
            }
        }else {
            let reminderDate = calculateReminder(startDate: startDate, reminderMe: presenter.newAction.reminderMe)
            DataSource.shared.createEvent(action: action, startDate: startDate, endDate: endDate, reminderDate: reminderDate)
        }
    }
    
    private func calculateReminder(startDate: Date, reminderMe: Reminder?) -> Date? {
        
        if let reminder = reminderMe, reminder.type != RemindMeType.noReminders.rawValue {
            
            var remindDate = startDate
            var remindTime : Date!
            
            if case .beforeTheDay? = RemindMeType(rawValue: reminder.type) {
                remindDate = startDate.beforeTheDay()
            }
            
            if reminder.timeInterval != 0 {
                let timeInterval = Int(reminder.timeInterval)
                remindTime = Date().convertIntToDate(time: timeInterval)
            }
            
            let hour = Calendar.current.component(.hour, from: remindTime)
            let minute = Calendar.current.component(.minute, from: remindTime)
            
            remindDate = remindDate.customTime(hour: hour, minute: minute)
            return remindDate
        }
        return nil
    }
    
    func checkRepeatDayOfWeek(repeatDays: DaysOfWeek?) -> Set<DaysOfWeekType> {
        
        var selectDaysSet = Set<DaysOfWeekType>()
        guard let repeatDays = repeatDays else { return Set<DaysOfWeekType>() }
        
        if repeatDays.monday == true {
            selectDaysSet.insert(.monday)
        }
        if repeatDays.tuesday == true {
            selectDaysSet.insert(.tuesday)
        }
        if repeatDays.wednesday == true {
            selectDaysSet.insert(.wednesday)
        }
        if repeatDays.thursday == true {
            selectDaysSet.insert(.thursday)
        }
        if repeatDays.friday == true {
            selectDaysSet.insert(.friday)
        }
        if repeatDays.saturday == true {
            selectDaysSet.insert(.saturday)
        }
        if repeatDays.sunday == true {
            selectDaysSet.insert(.sunday)
        }
        
        return selectDaysSet
    }
    
    @discardableResult
    private func createNewAction(goalID: String?, contentID: String?) -> Action {
        
        let newAction = DataSource.shared.createNewAction(goalID: goalID, contentID: contentID)
        presenter.newAction = newAction
        createModelView(action: newAction)
        return newAction
    }
    
    private func searchAction(actionID: String?) {
        
        if let actionIDTemp = actionID {
            DataSource.shared.searchAction(actionID: actionIDTemp) {[weak self] (action) in
                self?.presenter.newAction = action?.cloneInBackgroundContext()
                self?.presenter.updateAction = action
                if let searchAction = action {
                    self?.createModelView(action: searchAction)
                }
            }
        }
        
    }
    
    private func createModelView(action: Action) {
        
        var content : SmallContentViewModel?
        
        if case .createNewActionSheet(contentID: _) = presenter.baseConfigType {
            content = SmallContentViewModel(imagePath: action.content?.smallImage, title: L10n.Act.addToActionPlan, subtitle: action.content?.title, points: "+\(PointsForAction.congratulationsWithContentAction)", shapeIcon: Asset.addActionShape.image)
        }
        
        let modelView = CreateActionViewModel(name: action.name,
                                              startDate: dateFormatting(date: action.startDate! as Date),
                                              reminder: statusReminder(action: action),
                                              goal: currentGoal(goal: action.goal),
                                              stake: stakeStatus(action: action),
                                              content: content)
        
        completeUpdate(modelView)
    }
    
    private func dateFormatting(date: Date) -> String {
        return DateFormatter.formatting(type: .createGoalOrAction, date: date)
    }
    
    private func statusReminder(action: Action) -> String {
        return  RemindMeType.noReminders.rawValue == action.reminderMe?.type ? L10n.off : L10n.on
    }
    
    private func currentGoal(goal: Goal?) -> String {
        
        guard let goal = goal else { return "No goal" }
        
        return goal.name ?? "No name goal"
    }
    
    private func stakeStatus(action: Action) -> String {
        
        return action.stake == 0 ? "No stake" : NumberFormatter.stringForCurrency(Float(action.stake))
        
    }
}
