//
//  HomePresenter.swift
//  Bold
//
//  Created by Alexander Kovalov on 6/14/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation

enum HomePresenterInput {
    case menuShow
    case actionAll
    case actionItem
    case boldManifest
    case createGoal
}

protocol HomePresenterInputProtocol {
    func input(_ inputCase: HomePresenterInput)
}

enum HomePresenterOutput {
    //case <#case#>
}

protocol HomePresenterOutputProtocol {
    func input(_ outputCase: HomePresenterOutput)
}

class HomePresenter: PresenterProtocol {
    
    typealias View = HomeViewController
    typealias Interactor = HomeInteractor
    typealias Router = HomeRouter
    
    var viewController: View!
    var interactor: Interactor!
    var router: Router!
    
    required init(view: View) {
        self.viewController = view
    }
    
    required init?(coder aDecoder: NSCoder) {
        
    }
}
