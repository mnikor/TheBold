//
//  DownloadsPresenter.swift
//  Bold
//
//  Created by Alexander Kovalov on 8/27/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation

enum DownloadsPresenterInput {
    case close
}

protocol DownloadsPresenterInputProtocol: PresenterProtocol {
    func input(_ inputCase: DownloadsPresenterInput)
}

class DownloadsPresenter: DownloadsRouterInputProtocol {
    
    typealias View = DownloadsViewController
    typealias Interactor = DownloadsInteractor
    typealias Router = DownloadsRouter
    
    weak var viewController: View!
    var interactor: Interactor!
    var router: Router!
    
    required init?(coder aDecoder: NSCoder) {
        
    }
    
    required init(viewController: View) {
        self.viewController = viewController
    }
    
    func input(_ inputCase: DownloadsRouterInput) {
        switch inputCase {
        case .close:
            router.input(.close)
        }
    }
}
