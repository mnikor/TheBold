//
//  AllGoalsConfigurator.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/22/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation

class AllGoalsConfigurator: ConfiguratorProtocol {
    
    typealias View = AllGoalsViewController
    
    func configure(with viewController: View) {
        
        let presenter = AllGoalsPresenter(view: viewController)
        let interactor = AllGoalsInteractor(presenter: presenter)
        let router = AllGoalsRouter(viewController: viewController)
        
        viewController.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
    }
    
}
