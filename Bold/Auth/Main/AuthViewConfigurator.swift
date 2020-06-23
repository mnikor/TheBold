//
//  AuthViewConfigurator.swift
//  Bold
//
//  Created by Denis Grishchenko on 6/23/20.
//  Copyright © 2020 Alexander Kovalov. All rights reserved.
//

import Foundation

class AuthViewConfigurator: ConfiguratorProtocol {
    
    typealias View = AuthViewController
    
    func configure(with viewController: AuthViewController) {
        
        let presenter = AuthViewPresenter(view: viewController)
        let interactor = AuthViewInteractor(presenter: presenter)
        let router = AuthViewRouter(viewController: viewController)
        
        viewController.presenter = presenter
        
        presenter.interactor = interactor
        presenter.router = router
 
    }
    
}
