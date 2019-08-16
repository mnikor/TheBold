//
//  CalendarAndHistoryConfigurator.swift
//  Bold
//
//  Created by Admin on 8/16/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation

class CalendarAndHistoryConfigurator: ConfiguratorProtocol {
    
    typealias View = CalendarAndHistoryViewController
    
    //MARK: ConfiguratorProtocol
    
    func configure(with viewController: CalendarAndHistoryViewController) {
        
        let presenter = CalendarAndHistoryPresenter(view: viewController)
        let interactor = CalendarAndHistoryInteractor(presenter: presenter)
        let router = CalendarAndHistoryRouter(viewController: viewController)
        
        viewController.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
        
    }
}
