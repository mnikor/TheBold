//
//  ActConfigurator.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/22/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation

class ActConfigurator: ConfiguratorProtocol {
    
    typealias View = ActViewController
    
    //MARK: ConfiguratorProtocol
    
    func configure(with viewController: View) {
        
        let presenter = ActPresenter(view: viewController)
        let interactor = ActInteractor(presenter: presenter)
        let router = ActRouter(viewController: viewController)
        
        viewController.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
    }
}
