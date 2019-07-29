//
//  IdeasConfigurator.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/26/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation

class IdeasConfigurator: ConfiguratorProtocol {
    
    typealias View = IdeasViewController
    
    func configure(with viewController: View) {
        
        let presenter = IdeasPresenter(view: viewController)
        let interactor = IdeasInteractor(presenter: presenter)
        let router = IdeasRouter(viewController: viewController)
        
        viewController.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
    }
}
