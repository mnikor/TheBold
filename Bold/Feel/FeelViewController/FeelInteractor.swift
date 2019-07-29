//
//  FeelInteractor.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/22/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation

class FeelInteractor: InteractorProtocol {
    
    typealias Presenter = FeelPresenter
    
    weak var presenter: FeelPresenter!
    
    required init(presenter: Presenter) {
        self.presenter = presenter
    }
}
