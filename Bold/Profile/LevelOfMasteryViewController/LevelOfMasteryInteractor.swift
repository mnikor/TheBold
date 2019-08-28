//
//  LevelOfMasteryInteractor.swift
//  Bold
//
//  Created by Alexander Kovalov on 8/27/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation

class LevelOfMasteryInteractor: InteractorProtocol {
    
    typealias Presenter = LevelOfMasteryPresenter
    
    weak var presenter: Presenter!
    
    required init(presenter: Presenter) {
        self.presenter = presenter
    }
}
