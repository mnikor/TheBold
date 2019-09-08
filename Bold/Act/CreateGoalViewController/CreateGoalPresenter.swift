//
//  CreateGoalPresenter.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/23/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation

enum CreateGoalInputPresenter {
    case save
    case cancel
    case showDateAlert(DateAlertType)
    
    case createNewGoal
    case showIdeas
    
    case updateIdeas(IdeasType)
    case updateName(String)
    case updateStartDate(Date)
    case updateEndDate(Date)
    case updateColor(ColorGoalType)
    case updateIcon(IdeasType)
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
    
    var selectIdea: IdeasType = .none
    var modelView: CreateGoalViewModel! {
        didSet {
            self.dataSource = updateDataSource()
            self.viewController.tableView.reloadData()
        }
    }
    
    lazy var dataSource: [CreateGoalSectionModel] = {
        guard let modelView = modelView else {
            return []
        }
        return updateDataSource()
    }()
    
    required init(view: View) {
        self.viewController = view
    }
    
    required init?(coder aDecoder: NSCoder) {
    }
    
    func input(_ inputCase: CreateGoalInputPresenter) {
        switch inputCase {
        case .save:
            interactor.input(.saveGoal({ [weak self] in
                self?.router.input(.cancel)
            })) 
        case .cancel:
            interactor.input(.deleteGoal({ [weak self] in
                self?.router.input(.cancel)
            }))
        case .showIdeas:
            selectedIdea()
        case .updateIdeas(let idea):
            selectIdea = idea
            self.interactor.input(.updateName(idea.titleText()))
            self.interactor.input(.updateIcon(idea))
        case .showDateAlert(let typeAlert):
            selectedDate(typeAlert: typeAlert)
        case .updateColor(let color):
            self.interactor.input(.updateColor(color))
        case .updateIcon(let iconType):
            self.interactor.input(.updateIcon(iconType))
        case .createNewGoal:
            createNewGoal()
        default:
            return
        }
    }
    
    private func selectedIdea() {
        let ideasVC = StoryboardScene.Act.ideasViewController.instantiate()
        ideasVC.delegate = viewController
        ideasVC.selectIdea = selectIdea
        router.input(.ideasPresent(ideasVC))
    }
    
    private func selectedDate(typeAlert: DateAlertType) {
        let currentDate = typeAlert == .startDate ? modelView.startDate : modelView.endDate
        let alertVC = DateAlertViewController.createController(type: typeAlert, currentDate: currentDate) {[unowned self] (newDate) in
            if typeAlert == .startDate {
                self.interactor.input(.updateStartDate(newDate))
            }else {
                self.interactor.input(.updateEndDate(newDate))
            }
        }
        router.input(.presentDateAlert(alertVC))
    }
    
    private func updateDataSource() -> [CreateGoalSectionModel] {
        
        return [CreateGoalSectionModel(title: nil, items: [CreateGoalModel(type: .headerWriteActivity, modelValue: .header(.goal, modelView.nameGoal))
            ]),
                CreateGoalSectionModel(title: nil, items: [CreateGoalModel(type: .starts, modelValue: .date(modelView.startDateString)),
                                                           CreateGoalModel(type: .ends, modelValue: .date(modelView.endDateString)),
                                                           CreateGoalModel(type: .color, modelValue: .color(modelView.color)),
                                                           CreateGoalModel(type: .colorList, modelValue: .colors(modelView.colors, modelView.color))
                    ]),
                CreateGoalSectionModel(title: nil, items: [CreateGoalModel(type: .icons, modelValue: .icon(modelView.icon)),
                                                           CreateGoalModel(type: .iconsList, modelValue: .icons(modelView.icons, modelView.icon, modelView.color))
                    ])
        ]
    }
    
    private func createNewGoal() {
        interactor.input(.createNewGoal({ [weak self] (modelView) in
            self?.modelView = modelView
        }))
    }
}
