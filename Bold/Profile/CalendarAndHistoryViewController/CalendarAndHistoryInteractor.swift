//
//  CalendarAndHistoryInteractor.swift
//  Bold
//
//  Created by Admin on 8/16/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation

class CalendarAndHistoryInteractor: InteractorProtocol {
    
    typealias Presenter = CalendarAndHistoryPresenter
    
    weak var presenter: Presenter!
    
    required init(presenter: Presenter) {
        self.presenter = presenter
    }
}
