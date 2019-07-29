//
//  IdeasInteractor.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/26/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation

class IdeasInteractor: InteractorProtocol {
    
    typealias Presenter = IdeasPresenter
    
    var presenter: IdeasPresenter!
    
    required init(presenter: Presenter) {
        self.presenter = presenter
    }
    
}
