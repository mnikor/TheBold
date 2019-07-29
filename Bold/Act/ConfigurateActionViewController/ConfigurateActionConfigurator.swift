//
//  ConfigurateActionConfigurator.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/24/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation

class ConfigurateActionConfigurator: ConfiguratorProtocol {
    
    typealias View = ConfigurateActionViewController
    
    func configure(with viewController: View) {
        
        let presenter = ConfigurateActionPresenter(view: viewController)
        let interactor = ConfigurateActionInteractor(presenter: presenter)
        let router = ConfigurateActionRouter(viewController: viewController)
        
        viewController.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
    }
}
