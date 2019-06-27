//
//  HomeConfiguratorProtocol.swift
//  Bold
//
//  Created by Alexander Kovalov on 6/14/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation

class HomeConfigurator: ConfiguratorProtocol {

    typealias View = HomeViewController
    
    //MARK: ConfiguratorProtocol
    
    func configure(with viewController: View) {
        
        let presenter = HomePresenter(view: viewController)
        let router = HomeRouter(viewController: viewController)
        let interactor = HomeInteractor(presenter: presenter)
        
        viewController.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
    }
}
