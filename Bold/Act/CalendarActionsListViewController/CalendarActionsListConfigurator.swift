//
//  CalendarActionsListConfigurator.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/23/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation

class CalendarActionsListConfigurator: ConfiguratorProtocol {
    
    typealias View = CalendarActionsListViewController
    
    //MARK: ConfiguratorProtocol
    
    func configure(with viewController: CalendarActionsListViewController) {
        
        let presenter = CalendarActionsListPresenter(view: viewController)
        let interactor = CalendarActionsListInteractor(presenter: presenter)
        let router = CalendarActionsListRouter(viewController: viewController)
        
        viewController.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
        
    }
}
