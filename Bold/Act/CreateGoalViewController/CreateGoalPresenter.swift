//
//  CreateGoalPresenter.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/23/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation

enum CreateGoalInputPresenter {
    case ideas
    case save
    case cancel
    case showDateAlert(DateAlertType, Date)
    case writeTitle
    case selectIcon(IdeasType)
    case selectColor(ColorGoalType)
}

protocol CreateGoalInputPresenterProtocol {
    func input(_ inputCase: CreateGoalInputPresenter)
}

class CreateGoalPresenter: PresenterProtocol, CreateGoalInputPresenterProtocol {
    
    typealias View = CreateGoalViewController
    typealias Interactor = CreateGoalInteractor
    typealias Router = CreateGoalRouter
    
    weak var viewController: View!
    var interactor: Interactor!
    var router: Router!
    
    //lazy var goalCD
    
    lazy var newGoal: GoalTemp = {
        return GoalTemp(name: nil, startDate: Date(), endDate: Date(), color: .none, icon: .none)
    }()
    
    lazy var listSettings : [Array] = {
        return [
            [AddActionEntity(type: .headerWriteActivity, currentValue: nil)],
            
            [AddActionEntity(type: .starts, currentValue: "Thu, 1 Feb, 2019"),
             AddActionEntity(type: .ends, currentValue: "Thu, 1 Feb, 2019"),
             AddActionEntity(type: .color, currentValue: nil),
             AddActionEntity(type: .colorList, currentValue: nil)],
            
            [AddActionEntity(type: .icons, currentValue: nil),
             AddActionEntity(type: .iconsList, currentValue: nil)]]
    }()
    
    required init(view: View) {
        self.viewController = view
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
    }
    
    func input(_ inputCase: CreateGoalInputPresenter) {
        switch inputCase {
        case .ideas:
            router.input(.ideas)
        case .showDateAlert(let typeAlert, let currentDate):
            let alertVC = DateAlertViewController.createController(type: typeAlert, currentDate: currentDate) {[unowned self] (newDate) in
                print("selecDate = \(newDate)")
                if typeAlert == .startDate {
                    self.newGoal.startDate = newDate
                }else {
                    self.newGoal.endDate = newDate
                }
                self.viewController.tableView.reloadData()
            }
            router.input(.presentDateAlert(alertVC))
        case .selectColor(let color):
            newGoal.color = color
            viewController.tableView.reloadData()
        case .selectIcon(let iconType):
            newGoal.icon = iconType
            viewController.tableView.reloadData()
        default:
            print("dsf")
        }
    }
    
}
