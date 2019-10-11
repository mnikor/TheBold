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
    case actionAll(FeelTypeCell)
    case actionItem
    case unlockBoldManifest
    case createGoal
}

protocol HomePresenterInputProtocol {
    func input(_ inputCase: HomePresenterInput)
}

class HomePresenter: PresenterProtocol, HomePresenterInputProtocol {
    
    typealias View = HomeViewController
    typealias Interactor = HomeInteractor
    typealias Router = HomeRouter
    
    weak var viewController: View!
    var interactor: Interactor!
    var router: Router!
    
    required init(view: View) {
        self.viewController = view
    }
    
    required init?(coder aDecoder: NSCoder) {
        
    }
    
    lazy var actionItems : [HomeEntity] = {
        return [HomeEntity(type: .feel, items: [1, 2, 3, 4]),
                HomeEntity(type: .boldManifest, items: nil),
                HomeEntity(type: .think, items: [1, 2, 3, 4]),
                HomeEntity(type: .actActive, items: [1, 2, 3, 4]),
                HomeEntity(type: .actNotActive, items: [1])]
    }()
    
    func input(_ inputCase: HomePresenterInput) {
        
        switch inputCase {
        case .menuShow:
            router.input(.menuShow)
        case .actionAll(let type):
            router.input(.actionAll(type))
        case .actionItem:
            router.input(.actionItem)
        case .unlockBoldManifest:
            router.input(.unlockBoldManifest)
        case .createGoal:
            router.input(.createGoal)
        }
    }
}


