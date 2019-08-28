//
//  LevelOfMasteryConfigurator.swift
//  Bold
//
//  Created by Alexander Kovalov on 8/27/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation

class LevelOfMasteryConfigurator: ConfiguratorProtocol {
    
    typealias View = LevelOfMasteryViewController
    
    func configure(with viewController: View) {
        let presenter = LevelOfMasteryPresenter(view: viewController)
        let interactor = LevelOfMasteryInteractor(presenter: presenter)
        let router = LevelOfMasteryRouter(viewController: viewController)
        
        viewController.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
    }
}
