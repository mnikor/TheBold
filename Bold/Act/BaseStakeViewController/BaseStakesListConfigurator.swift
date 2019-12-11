//
//  BaseStakesListConfigurator.swift
//  Bold
//
//  Created by Alexander Kovalov on 19.11.2019.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation

class BaseStakesListConfigurator: ConfiguratorProtocol {
    
    typealias View = BaseStakesListViewController
    
    //MARK: ConfiguratorProtocol
    
    func configure(with viewController: BaseStakesListViewController) {
        
        let presenter = BaseStakesListPresenter(view: viewController)
        let interactor = BaseStakesListInteractor(presenter: presenter)
        let router = BaseStakesListRouter(viewController: viewController)
        
        viewController.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
        
    }
}
