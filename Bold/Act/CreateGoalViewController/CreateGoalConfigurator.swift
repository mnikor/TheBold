//
//  CreateGoalConfigurator.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/23/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation

class CreateGoalConfigurator: ConfiguratorProtocol {
    
    typealias View = CreateGoalViewController
    
    //MARK: ConfiguratorProtocol
    
    func configure(with viewController: View) {
        
        let presenter = CreateGoalPresenter(view: viewController)
        let interactor = CreateGoalInteractor(presenter: presenter)
        let router = CreateGoalRouter(viewController: viewController)
        
        viewController.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
    }
}
