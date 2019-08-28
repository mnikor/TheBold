//
//  ArchivedGoalsPresenter.swift
//  Bold
//
//  Created by Alexander Kovalov on 8/27/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation

enum ArchivedGoalsPresenterInput {
    case close
}

protocol ArchivedGoalsPresenterInputProtocol:PresenterProtocol {
    func input(_ inputCase:ArchivedGoalsPresenterInput)
}

class ArchivedGoalsPresenter: ArchivedGoalsPresenterInputProtocol {
    
    typealias View = ArchivedGoalsViewController
    typealias Interactor = ArchivedGoalsInteractor
    typealias Router = ArchivedGoalsRouter
    
    weak var viewController: ArchivedGoalsViewController!
    var interactor: ArchivedGoalsInteractor!
    var router: ArchivedGoalsRouter!
    
    required init?(coder aDecoder: NSCoder) {
    }
    
    required init(view: View) {
        self.viewController = view
    }
    
    func input(_ inputCase: ArchivedGoalsPresenterInput) {
        switch inputCase {
        case .close:
            router.input(.close)
        }
    }
}
