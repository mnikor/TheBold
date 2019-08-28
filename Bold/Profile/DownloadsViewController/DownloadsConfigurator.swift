//
//  DownloadsConfigurator.swift
//  Bold
//
//  Created by Alexander Kovalov on 8/27/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation

class DownloadsConfigurator: ConfiguratorProtocol {
    
    typealias View = DownloadsViewController
    
    func configure(with viewController: View) {
        
        let presenter = DownloadsPresenter(viewController: viewController)
        let interactor = DownloadsInteractor(presenter: presenter)
        let router = DownloadsRouter(viewController: viewController)
        
        viewController.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
    }
}
