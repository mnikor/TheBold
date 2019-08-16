//
//  AccountDetailsConfigurator.swift
//  Bold
//
//  Created by Admin on 8/15/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation

class AccountDetailsConfigurator: ConfiguratorProtocol {
    typealias View = AccountDetailsViewController
    
    func configure(with viewController: View) {
        let presenter = AccountDetailsPresenter(view: viewController)
        let interactor = AccountDetailsInteractor(presenter: presenter)
        let router = AccountDetailsRouter(viewController: viewController)
        
        viewController.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
    }
}
