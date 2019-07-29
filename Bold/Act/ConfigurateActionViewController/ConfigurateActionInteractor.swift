//
//  ConfigurateActionInteractor.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/24/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation

class ConfigurateActionInteractor: InteractorProtocol {
    
    typealias Presenter = ConfigurateActionPresenter
    
    weak var presenter: Presenter!
    
    required init(presenter: Presenter) {
        self.presenter = presenter
    }
    
}
