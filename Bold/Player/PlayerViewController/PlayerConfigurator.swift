//
//  PlayerConfigurator.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/23/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation

class PlayerConfigurator: ConfiguratorProtocol {
    
    typealias View = PlayerViewController
    
    func configure(with viewController: PlayerViewController) {
        
        let presenter = PlayerPresenter(view: viewController)
        let interactor = PlayerInteractor(presenter: presenter)
        let router = PlayerRouter(viewController: viewController)
        
        viewController.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
    }
}
