//
//  ActionsListInteractor.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/22/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation

class ActionsListInteractor: InteractorProtocol {
    
    typealias Presenter = ActionsListPresenter
    
    weak var presenter: ActionsListPresenter!
    
    required init(presenter: Presenter) {
        self.presenter = presenter
    }
}
