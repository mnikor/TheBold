//
//  ConfigurateActionPresenter.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/24/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation

enum ConfigurateActionInputPresenter {
    case qq
}

protocol ConfigurateActionInputPresenterProtocol {
    func input(_ inputCase: ConfigurateActionInputPresenter)
}

class ConfigurateActionPresenter: PresenterProtocol, ConfigurateActionInputPresenterProtocol {
    
    typealias View = ConfigurateActionViewController
    typealias Interactor = ConfigurateActionInteractor
    typealias Router = ConfigurateActionRouter
    
    weak var viewController: View!
    var interactor: Interactor!
    var router: Router!
    
    required init(view: View) {
        self.viewController = view
    }
    
    required init?(coder aDecoder: NSCoder) {
    }
    
    func input(_ inputCase: ConfigurateActionInputPresenter) {
        switch inputCase {
        case .qq:
            print("sdf")
        default:
            print("dsf")
        }
    }
    
    
}
