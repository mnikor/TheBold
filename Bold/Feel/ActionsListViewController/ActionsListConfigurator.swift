//
//  ActionsListConfigurator.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/22/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation

class ActionsListConfigurator: ConfiguratorProtocol {
    
    typealias View = ActionsListViewController
    
    func configure(with viewController: View) {
        
        let presenter = ActionsListPresenter(view: viewController)
        let interactor = ActionsListInteractor(presenter: presenter)
        let router = ActionsListRouter(viewController: viewController)
        
        viewController.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
    }
    
}
