//
//  CreateGoalInteractor.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/23/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation

typealias completeBackGoalModel = (CreateGoalViewModel)->Void

enum CreateGoalInputInteractor {
    case createNewGoal(completeBackGoalModel)
    case editGoal(Goal, completeBackGoalModel)
    case updateGoal(VoidCallback)
    case saveGoal(VoidCallback)
    case deleteGoal(VoidCallback)
    
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
        case .editGoal(let goal, let complete):
            completeUpdate = complete
            newGoal = goal
            createModelView(goal: goal)
        case .updateGoal(let complete):
            DataSource.shared.saveBackgroundContext()
            complete()
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
            newGoal.endDate = date.checkValidateDate(date: newGoal.endDate, isStartDate: false)
            createModelView(goal: newGoal)
        case .updateEndDate(let date):
            newGoal.endDate = date as NSDate
            newGoal.startDate = date.checkValidateDate(date: newGoal.startDate, isStartDate: true)
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
        newGoal = DataSource.shared.createNewGoal()
        createModelView(goal: newGoal)
    }
    
    private func createModelView(goal: Goal) {
        
        var startDate = Date()
        var endDate = Date()
        
        if let date = goal.startDate { startDate = date as Date }
        if let date = goal.endDate { endDate = date as Date }
        
        let modelView = CreateGoalViewModel(startDate: startDate,
                                            startDateString: dateFormatting(date: startDate),
                                            endDate: endDate,
                                            endDateString: dateFormatting(date: endDate),
                                            color: ColorGoalType(rawValue: goal.color)!,
                                            icon: IdeasType(rawValue: goal.icon)!,
                                            nameGoal: goal.name,
                                            colors: colors,
                                            icons: icons)
        
        completeUpdate(modelView)
    }
    
    private func dateFormatting(date: Date) -> String {
        return DateFormatter.formatting(type: .createGoalOrAction, date: date)
    }
    
    private func saveGoal(complete: VoidCallback) {
        DataSource.shared.saveBackgroundContext()
        complete()
    }
    
    private func deleteGoal(goal: Goal, complete: @escaping VoidCallback) {
        
        DataSource.shared.deleteGoal(goalID: goal.id!, success: complete)
        complete()
    }
}
