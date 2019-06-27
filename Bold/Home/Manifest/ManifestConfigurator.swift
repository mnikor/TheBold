//
//  ManifestConfigurator.swift
//  Bold
//
//  Created by Alexander Kovalov on 6/21/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation

class ManifestConfigurator: ConfiguratorProtocol {
    
    typealias View = ManifestViewController
    
    func configure(with viewController: ManifestViewController) {
        
        let presenter = ManifestPresenter(view: viewController)
        let router = ManifestRouter(viewController: viewController)
        let interactor = ManifestInteractor(presenter: presenter)
        
        viewController.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
    }
}
