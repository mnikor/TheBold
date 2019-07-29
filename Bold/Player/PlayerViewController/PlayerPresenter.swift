//
//  PlayerPresenter.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/23/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation

enum PlayerInputPresenter {
    case ww
}

protocol PlayerInputPresenterProtocol {
    func input(_ inputCase: PlayerInputPresenter)
}

class PlayerPresenter: PresenterProtocol, PlayerInputPresenterProtocol {
    
    typealias View = PlayerViewController
    typealias Interactor = PlayerInteractor
    typealias Router = PlayerRouter
    
    weak var viewController: View!
    var interactor: Interactor!
    var router: Router!
    
    required init(view: View) {
        self.viewController = view
    }
    
    required init?(coder aDecoder: NSCoder) {
    }
    
    func input(_ inputCase: PlayerInputPresenter) {
        switch inputCase {
        case .ww:
            print("dfs")
        default:
            print("dsfsf")
        }
    }
    
    
}


struct StateStatusButtonToolbar {
    var dowload: Bool = false
    var like: Bool = false
}
