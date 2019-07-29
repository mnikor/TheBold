//
//  FeelPresenter.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/22/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation

enum FeelPresenterInput  {
    case menuShow
    case showAll(FeelTypeCell)
    case showPlayer
}

protocol FeelPresenterProtocol {
    func input(_ inputCase: FeelPresenterInput)
}

class FeelPresenter: PresenterProtocol, FeelPresenterProtocol {
    
    typealias View = FeelViewController
    typealias Interactor = FeelInteractor
    typealias Router = FeelRouter
    
    weak var viewController: View!
    var interactor: Interactor!
    var router: Router!
    
    required init(view: View) {
        self.viewController = view
    }
    
    required init?(coder aDecoder: NSCoder) {
        
    }
    
    lazy var feelItems : [FeelEntity] = {
        return [FeelEntity(type: .meditation, items: [1, 2, 3 ,4]),
                FeelEntity(type: .hypnosis, items: [1, 2, 3]),
                FeelEntity(type: .pepTalk, items: [1, 2, 3, 4, 5])]
        
    }()
    
    func input(_ inputCase: FeelPresenterInput) {
        switch inputCase {
        case .menuShow:
            router.input(.menuShow)
        case .showAll(let typeCell):
            router.input(.showAll(typeCell))
        case .showPlayer:
            router.input(.showPlayer)
        }
    }
}

struct FeelEntity {
    var type : FeelTypeCell
    var items: Array<Any>
}
