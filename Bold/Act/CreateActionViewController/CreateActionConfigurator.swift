//
//  CreateActionConfigurator.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/23/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation

class CreateActionConfigurator: ConfiguratorProtocol {
    
    typealias View = CreateActionViewController
    
    //MARK: ConfiguratorProtocol
    
    func configure(with viewController: View) {
        
        let presenter = CreateActionPresenter(view: viewController)
        let interactor = CreateActionInteractor(presenter: presenter)
        let router = CreateActionRouter(viewController: viewController)
        
        viewController.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
    }
}
