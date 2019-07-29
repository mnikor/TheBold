//
//  PlayerRouter.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/23/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation

enum PlayerInputRouter {
    case aa
}

protocol PlayerInputRouterProtocol {
    func input(_ inputCase: PlayerInputRouter)
}

class PlayerRouter: RouterProtocol, PlayerInputRouterProtocol {
    
    typealias View = PlayerViewController
    
    weak var viewController: View!
    
    required init(viewController: View) {
        self.viewController = viewController
    }
    
    func input(_ inputCase: PlayerInputRouter) {
        switch inputCase {
        case .aa:
            print("dsf")
        default:
            print("sdfs")
        }
    }
}
