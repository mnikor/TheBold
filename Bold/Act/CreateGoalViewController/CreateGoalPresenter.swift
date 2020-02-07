//
//  CreateGoalPresenter.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/23/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation

enum CreateGoalControllerConfigType {
    case createNewGoalVC
    case editGoalSheet(goalID: String)
}

extension CreateGoalControllerConfigType : Equatable {
    
    public static func ==(lhs: CreateGoalControllerConfigType, rhs: CreateGoalControllerConfigType) -> Bool {
        
        switch (lhs, rhs) {
        case (.createNewGoalVC, .createNewGoalVC):
            return true
        case (.editGoalSheet, .editGoalSheet):
            return true
        case (.editGoalSheet(goalID: let a), .editGoalSheet(goalID: let b)):
            return a == b
        case (.editGoalSheet(_), _):
            return false
        case (.editGoalSheet, .createNewGoalVC):
            return false
        case (.createNewGoalVC, .editGoalSheet):
            return false
        case (_, .editGoalSheet(_)):
            return false
        }
    }
}

enum CreateGoalInputPresenter {
    case save
    case cancel
    
    case createNewGoal
    case editGoal(goalID: String)
    case updateGoal(VoidCallback)
    case showIdeas
    case updateDataSource
    
    case updateIdeas(IdeasType)
    case updateName(String)
    case showDateAlert(DateAlertType)
//    case updateStartDate(Date)
//    case updateEndDate(Date)
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
    
    var baseConfigType = CreateGoalControllerConfigType.createNewGoalVC
    var selectIdea: IdeasType = .none
    var modelView: CreateGoalViewModel! {
        didSet {
            self.dataSource = updateDataSource()
            self.viewController.input(.updateState)
        }
    }
    
    var isEditAction: Bool = false {
        didSet {
            tapEditCallback?()
        }
    }
    var tapEditCallback : VoidCallback?
    
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
        case .updateGoal(let complete):
            interactor.input(.updateGoal(complete))
        case .showIdeas:
            selectedIdea()
        case .updateDataSource:
            self.dataSource = updateDataSource()
            self.viewController.input(.updateState)
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
        case .editGoal(goalID: let goalID):
            editGoalID(goalID)
//        case .updateStartDate(_):
//            print("case .updateStartDate(_)")
//        case .updateEndDate(_):
//            print("case .updateEndDate(_)")
        }
    }
    
    func editGoalID(_ goalID: String) {
        DataSource.shared.searchGoal(goalID: goalID) {[unowned self] (findGoal) in
            
            guard let goal = findGoal else {return}
            interactor.input(.editGoal(goal, {[weak self] (modelView) in
                self?.modelView = modelView
            }))
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
        
        return [headerGoalSectionModel(),
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
    
    private func headerGoalSectionModel() -> CreateGoalSectionModel {
        if baseConfigType == .createNewGoalVC {
            return CreateGoalSectionModel(title: nil,
                                          items: [CreateGoalActionModel(type: .headerWriteActivity, modelValue: .header(.goal, modelView.nameGoal))
            ])
        }else {
            return CreateGoalSectionModel(title: nil,
                                          items: [CreateGoalActionModel(type: .headerEditAction, modelValue: .headerEdit(statusEdit: isEditAction, name: modelView.nameGoal))
            ])
        }
    }
    
    private func createNewGoal() {
        interactor.input(.createNewGoal({ [weak self] (modelView) in
            self?.modelView = modelView
        }))
    }
}
