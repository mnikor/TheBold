//
//  CreateActionPresenter.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/23/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation

enum CreateActionControllerConfigType {
    case createNewActionVC
    case createNewActionSheet(contentID: String?)
    case editActionSheet(actionID: String?)
}

extension CreateActionControllerConfigType: Equatable {
    
    public static func ==(lhs: CreateActionControllerConfigType, rhs: CreateActionControllerConfigType) -> Bool {
        
        switch (lhs, rhs) {
        case (.createNewActionVC, .createNewActionVC):
            return true
        case (.createNewActionSheet, .createNewActionSheet):
            return true
        case (.editActionSheet(actionID: let a), .editActionSheet(actionID: let b)):
            return a == b
        case (.editActionSheet(_), _):
            return false
        case (.createNewActionSheet, .createNewActionVC):
            return false
        case (.createNewActionVC, .createNewActionSheet):
            return false
        case (_, .editActionSheet(_)):
            return false
        }
        
    }
    
}

enum CreateActionInputPresenter {
    case setting(AddActionCellType)
    case stake
    case share
    case save
    case saveWithContent(contentId: String?)
    case cancel
    case validate(nameAction: String)
    
    case createNewAction
    case searchAction(actionID: String?)
    case updateAction(success: ()->Void)
    case deleteAction(success: ()->Void)
    
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
    var contentID: String?
    var newAction: Action!
    var updateAction: Action!
    var isEditAction: Bool = false {
        didSet {
            tapEditCallback?()
        }
    }
    var tapEditCallback : VoidCallback?
    var baseConfigType = CreateActionControllerConfigType.createNewActionVC
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
    
    required init(view: View) {
        self.viewController = view
    }
    
    required init?(coder aDecoder: NSCoder) {
        
    }
    
    func input(_ inputCase: CreateActionInputPresenter) {
        switch inputCase {
        case .createNewAction:
            createNewAction()
        case .searchAction(actionID: let actionID):
            editAction(actionID: actionID)
        case .updateAction(success: let success):
            updateAction(success: success)
        case .updateName(let name):
            interactor.input(.updateName(name))
        case .updateConfiguration:
            if let name = newAction.name {
                input(.validate(nameAction: name))
            }
            interactor.input(.updateConfiguration)
        case .updateStake(let stake):
            interactor.input(.updateStake(stake))
        case .deleteAction(success: let success):
            deleteAction(success)
            
        case .setting(let settingType):
            router.input(.presentSetting(settingType))
        case .stake:
            router.input(.stake)
        case .share:
            router.input(.share)
        case .save:
            viewController.view.endEditing(true)
            interactor.input(.saveAction({ [unowned self] in
                //self.viewController.delegate?.actionWasCreated()
                self.router.input(.cancel)
            }))
        case .cancel:
            deleteAction { [unowned self] in
                self.router.input(.cancel)
            }
        case .validate(nameAction: let name):
            viewController.navBar.topItem?.rightBarButtonItem?.isEnabled = (name.count >= 3 && newAction.goal != nil)
        case .saveWithContent(contentId: let contentId):
            viewController.view.endEditing(true)
            interactor.input(.saveActionWithContent(contentID: contentId, completion: { [weak self] in
                self?.router.input(.cancel)
            }))
        }
    }
    
    private func updateDataSource() -> [CreateGoalSectionModel] {
        
        let headerCell : CreateGoalSectionModel!
        
        switch baseConfigType {
        case .createNewActionVC:
            headerCell = CreateGoalSectionModel(title: nil, items: [CreateGoalActionModel(type: .headerWriteActivity, modelValue: .header(.action, modelView.name))])
        case .createNewActionSheet:
            headerCell = CreateGoalSectionModel(title: nil, items: [CreateGoalActionModel(type: .headerAddToPlan, modelValue: .headerContent(modelView.content))])
        case .editActionSheet:
            headerCell = CreateGoalSectionModel(title: nil, items: [CreateGoalActionModel(type: .headerEditAction, modelValue: .headerEdit(statusEdit: isEditAction, name: modelView.name))])
        }
        
        return [headerCell,
                CreateGoalSectionModel(title: nil, items: [CreateGoalActionModel(type: .when, modelValue: .date(modelView.startDate)),
                                                           CreateGoalActionModel(type: .reminder, modelValue: .value(modelView.reminder)),
                                                           CreateGoalActionModel(type: .goal, modelValue: .value(modelView.goal))
                    ]),
                CreateGoalSectionModel(title: nil, items: [CreateGoalActionModel(type: .stake, modelValue: .value(modelView.stake)),
                                                           CreateGoalActionModel(type: .share, modelValue: .none)
                    ])
        ]
    }
    
    private func createNewAction() {
        interactor.input(.createNewAction(goalID: goalID, contentID: contentID, { [weak self] (modelView) in
            self?.modelView = modelView
        }))
    }
    
    private func editAction(actionID: String?) {
        interactor.input(.searchAction(actionID: actionID, { [weak self] (modelView) in
            self?.modelView = modelView
        }))
    }
    
    private func updateAction(success: ()->Void) {
        interactor.input(.updateAction({
            print("Update Action Completed !!!")
        }))
    }
    
    private func deleteAction(_ complete:()->Void) {
        if newAction != nil {
            DataSource.shared.backgroundContext.delete(newAction)
        }
        if updateAction != nil {
            DataSource.shared.backgroundContext.delete(updateAction)
        }
        DataSource.shared.saveBackgroundContext()
        complete()
    }
}
