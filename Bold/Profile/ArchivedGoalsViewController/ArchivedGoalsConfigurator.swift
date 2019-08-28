//
//  ArchivedGoalsConfigurator.swift
//  Bold
//
//  Created by Alexander Kovalov on 8/27/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation

class ArchivedGoalsConfigurator: ConfiguratorProtocol {

    typealias View = ArchivedGoalsViewController
    
    func configure(with viewController: View) {
        let presenter = ArchivedGoalsPresenter(view: viewController)
        let interactor = ArchivedGoalsInteractor(presenter: presenter)
        let router = ArchivedGoalsRouter(viewController: viewController)
        
        viewController.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
    }
}
