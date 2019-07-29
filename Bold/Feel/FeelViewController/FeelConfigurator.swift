//
//  FeelConfigurator.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/22/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation

class FeelConfigurator: ConfiguratorProtocol {
    
    typealias View = FeelViewController

    func configure(with viewController: View) {
        
        let presenter = FeelPresenter(view: viewController)
        let interactor = FeelInteractor(presenter: presenter)
        let router = FeelRouter(viewController: viewController)
        
        viewController.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
    }
}
