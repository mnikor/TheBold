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
    
    lazy var listSettings : [Array] = {
        return [
            [AddActionEntity(type: .headerWriteActivity, currentValue: nil)],
            
            [AddActionEntity(type: .duration, currentValue: "Thu, 1 Feb, 2019"),
            AddActionEntity(type: .reminder, currentValue: "Off"),
            AddActionEntity(type: .goal, currentValue: "Marathon")],
            
            [AddActionEntity(type: .stake, currentValue: "No stake"),
            AddActionEntity(type: .share, currentValue: nil)]]
    }()
    
    required init(view: View) {
        self.viewController = view
    }
    
    required init?(coder aDecoder: NSCoder) {
        
    }
    
    func input(_ inputCase: CreateActionInputPresenter) {
        switch inputCase {
        case .setting(let settingType):
            router.input(.presentSetting(settingType))
        case .stake:
            router.input(.stake)
        case .share:
            router.input(.share)
        case .save:
            // TODO: Create notification and save action
            break
        }
    }
}
