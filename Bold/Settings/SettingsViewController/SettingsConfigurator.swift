//
//  SettingsConfigurator.swift
//  Bold
//
//  Created by Anton Klysa on 8/16/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation

class SettingsConfigurator: ConfiguratorProtocol {
    
    //MARK: ConfiguratorProtocol
    
    typealias View = SettingsViewController
    
    func configure(with viewController: View) {
        
        let presenter = SettingsPresenter(view: viewController)
        let interactor = SettingsInteractor(presenter: presenter)
        let router = SettingsRouter(viewController: viewController)
        
        viewController.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
    }
}
