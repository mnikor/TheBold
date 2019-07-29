//
//  CalendarActionsListInteractor.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/23/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation

class CalendarActionsListInteractor: InteractorProtocol {
    
    typealias Presenter = CalendarActionsListPresenter
    
    weak var presenter: Presenter!
    
    required init(presenter: Presenter) {
        self.presenter = presenter
    }
}
