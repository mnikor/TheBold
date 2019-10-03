//
//  CreateActionPresenter.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/23/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation

enum CreateActionInputPresenter {
    case setting(AddActionCellType)
    case stake
    case share
    case save
    case cancel
    
    case createNewAction
    case updateName(String)
    case updateConfiguration
    case updateStake(Float)
}

protocol CreateActionInputProtocol {
    func input(_ inputCase: CreateActionInputPresenter)
}

class CreateActionPresenter: PresenterProtocol, CreateActionInputProtocol {
    
    typealias View = CreateActionViewController
    typealias Interactor = CreateActionInteractor
    typealias Router = CreateActionRouter
    
    weak var viewController: View!
    var interactor: Interactor!
    var router: Router!
    
    var goalID: String?
    var newAction: Action!
    
    var modelView: CreateActionViewModel! {
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
    
    private func updateDataSource() -> [CreateGoalSectionModel] {
        
        return [CreateGoalSectionModel(title: nil, items: [CreateGoalActionModel(type: .headerWriteActivity, modelValue: .header(.action, modelView.name))
                    ]),
                CreateGoalSectionModel(title: nil, items: [CreateGoalActionModel(type: .when, modelValue: .date(modelView.startDate)),
                                                           CreateGoalActionModel(type: .reminder, modelValue: .value(modelView.reminder)),
                                                           CreateGoalActionModel(type: .goal, modelValue: .value(modelView.goal))
                    ]),
                CreateGoalSectionModel(title: nil, items: [CreateGoalActionModel(type: .stake, modelValue: .value(modelView.stake)),
                                                           CreateGoalActionModel(type: .share, modelValue: .none)
                    ])
        ]
    }
    
    required init(view: View) {
        self.viewController = view
    }
    
    required init?(coder aDecoder: NSCoder) {
        
    }
    
    func input(_ inputCase: CreateActionInputPresenter) {
        switch inputCase {
        case .createNewAction:
            createNewAction()
        case .updateName(let name):
            interactor.input(.updateName(name))
        case .updateConfiguration:
            interactor.input(.updateConfiguration)
        case .updateStake(let stake):
            interactor.input(.updateStake(stake))
            
        case .setting(let settingType):
            router.input(.presentSetting(settingType))
        case .stake:
            router.input(.stake)
        case .share:
            router.input(.share)
        case .save:
            interactor.input(.saveAction({ [unowned self] in
                //self.viewController.delegate?.actionWasCreated()
                self.router.input(.cancel)
            }))
        case .cancel:
            interactor.input(.deleteAction({ [unowned self] in
                self.router.input(.cancel)
            }))
            
        }
    }
    
    private func createNewAction() {
        interactor.input(.createNewAction(goalID: goalID, { [weak self] (modelView) in
            self?.modelView = modelView
        }))
    }
}
