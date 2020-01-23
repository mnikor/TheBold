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
            self.viewController.input(.updateState)
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
            viewController.view.endEditing(true)
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
        case .updateName(let name):
            self.interactor.input(.updateName(name))
        case .showDateAlert(let typeAlert):
            selectedDate(typeAlert: typeAlert)
        case .updateColor(let color):
            self.interactor.input(.updateColor(color))
        case .updateIcon(let iconType):
            self.interactor.input(.updateIcon(iconType))
        case .createNewGoal:
            createNewGoal()
        case .updateStartDate(_):
            print("case .updateStartDate(_)")
        case .updateEndDate(_):
            print("case .updateEndDate(_)")
        }
    }
    
    private func selectedIdea() {
        if UserDefaults.standard.bool(forKey: "BoldTips") {
            let ideasVC = StoryboardScene.Act.ideasViewController.instantiate()
            ideasVC.delegate = viewController
            ideasVC.selectIdea = selectIdea
            router.input(.ideasPresent(ideasVC))
        } else {
            UserDefaults.standard.set(true, forKey: "BoldTips")
            
        let vc = StoryboardScene.Description.boldTipsViewController.instantiate()
            vc.delegate = viewController
            vc.selectIdea = selectIdea
            viewController.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func selectedDate(typeAlert: DateAlertType) {
        let currentDate = typeAlert == .startDate ? modelView.startDate : modelView.endDate
        let alertVC = DateAlertViewController.createController(type: typeAlert, currentDate: currentDate, startDate: nil, endDate: nil) {[unowned self] (newDate) in
            if typeAlert == .startDate {
                self.interactor.input(.updateStartDate(newDate))
            }else {
                self.interactor.input(.updateEndDate(newDate))
            }
            self.viewController.dismiss(animated: true)
        }
        router.input(.presentDateAlert(alertVC))
    }
    
    private func updateDataSource() -> [CreateGoalSectionModel] {
        
        return [CreateGoalSectionModel(title: nil, items: [CreateGoalActionModel(type: .headerWriteActivity, modelValue: .header(.goal, modelView.nameGoal))
                    ]),
                CreateGoalSectionModel(title: nil, items: [CreateGoalActionModel(type: .starts, modelValue: .date(modelView.startDateString)),
                                                           CreateGoalActionModel(type: .ends, modelValue: .date(modelView.endDateString)),
                                                           CreateGoalActionModel(type: .color, modelValue: .color(modelView.color)),
                                                           CreateGoalActionModel(type: .colorList, modelValue: .colors(modelView.colors, modelView.color))
                    ]),
                CreateGoalSectionModel(title: nil, items: [CreateGoalActionModel(type: .icons, modelValue: .icon(modelView.icon)),
                                                           CreateGoalActionModel(type: .iconsList, modelValue: .icons(modelView.icons, modelView.icon, modelView.color))
                    ])
        ]
    }
    
    private func createNewGoal() {
        interactor.input(.createNewGoal({ [weak self] (modelView) in
            self?.modelView = modelView
        }))
    }
}
