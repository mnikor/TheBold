//
//  CreateGoalInteractor.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/23/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation

typealias completeBackGoalModel = (CreateGoalViewModel)->Void
typealias completeGoal = ()->Void

enum CreateGoalInputInteractor {
    case createNewGoal(completeBackGoalModel)
    case saveGoal(completeGoal)
    case deleteGoal(completeGoal)
    
    case updateName(String?)
    case updateStartDate(Date)
    case updateEndDate(Date)
    case updateColor(ColorGoalType)
    case updateIcon(IdeasType)
}

protocol CreateGoalInputInteractorProtocol: InteractorProtocol {
    func input(_ inputCase: CreateGoalInputInteractor)
}

class CreateGoalInteractor: CreateGoalInputInteractorProtocol {
    
    typealias Presenter = CreateGoalPresenter
    
    weak var presenter: Presenter!
    
    private var newGoal: Goal!
    private var completeUpdate: completeBackGoalModel!
    
    private lazy var colors : [ColorGoalType] = {
        return [.orange, .red, .blueDark, .green, .yellow, .blue]
    }()
    
    private lazy var icons : [IdeasType] = {
        return [.marathon, .triathlon, .charityProject, .writeBook, .quitSmoking, .publicSpeech, .skyDiving, .launchStartUp, .competeToWin, .startNewProject, .killProject, .findNewJob, .makeDiscovery, .inventSomething, .income, .masterSkill]
    }()
    
    required init(presenter: Presenter) {
        self.presenter = presenter
    }
    
    func input(_ inputCase: CreateGoalInputInteractor) {
        switch inputCase {
        case .createNewGoal(let complete):
            completeUpdate = complete
            createnewGoal()
        case .saveGoal(let complete):
            saveGoal(complete: complete)
        case .deleteGoal(let complete):
            deleteGoal(goal: newGoal, complete: complete)
        case .updateName(let name):
            if name != nil {
                newGoal.name = name
                createModelView(goal: newGoal)
            }
        case .updateStartDate(let date):
            newGoal.startDate = date as NSDate
            checkValidateDate(date: date, isStartDate: true)
            createModelView(goal: newGoal)
        case .updateEndDate(let date):
            newGoal.endDate = date as NSDate
            checkValidateDate(date: date, isStartDate: false)
            createModelView(goal: newGoal)
        case .updateColor(let colorType):
            newGoal.color = Int16(colorType.rawValue)
            createModelView(goal: newGoal)
        case .updateIcon(let iconType):
            newGoal.icon = Int16(iconType.rawValue)
            createModelView(goal: newGoal)
        }
    }
    
    private func createnewGoal() {
        newGoal = Goal()
        newGoal.id = newGoal.objectID.uriRepresentation().lastPathComponent
        newGoal.startDate = Date() as NSDate
        newGoal.endDate = Date() as NSDate
        newGoal.color = ColorGoalType.orange.rawValue
        newGoal.icon = IdeasType.marathon.rawValue
        newGoal.status = StatusType.wait.rawValue
        
        createModelView(goal: newGoal)
    }
    
    private func createModelView(goal: Goal) {
        
        let modelView = CreateGoalViewModel(startDate: goal.startDate! as Date,
                                            startDateString: dateFormatting(date: goal.startDate! as Date),
                                            endDate: goal.endDate! as Date,
                                            endDateString: dateFormatting(date: goal.endDate! as Date),
                                            color: ColorGoalType(rawValue: goal.color)!,
                                            icon: IdeasType(rawValue: goal.icon)!,
                                            nameGoal: goal.name,
                                            colors: colors,
                                            icons: icons)
        
        completeUpdate(modelView)
    }
    
    private func checkValidateDate(date:Date, isStartDate: Bool) {
        
        if isStartDate {
            if date > newGoal.endDate! as Date {
                newGoal.endDate = date as NSDate
            }
        }else {
            if date < newGoal.startDate! as Date {
                newGoal.startDate = date as NSDate
            }
        }
        
    }
    
    private func dateFormatting(date: Date) -> String {
        return DateFormatter.formatting(type: .createGoalOrAction, date: date)
    }
    
    private func saveGoal(complete: completeGoal) {
        DataSource.shared.saveBackgroundContext()
        complete()
    }
    
    private func deleteGoal(goal: Goal, complete: completeGoal) {
        DataSource.shared.backgroundContext.delete(goal)
        DataSource.shared.saveBackgroundContext()
        complete()
    }
}
