//
//  AuthViewRouter.swift
//  Bold
//
//  Created by Denis Grishchenko on 6/23/20.
//  Copyright © 2020 Alexander Kovalov. All rights reserved.
//

import Foundation

protocol AuthViewRouterInputProtocol: class {
    
}

class AuthViewRouter: RouterProtocol, AuthViewRouterInputProtocol {
    
    typealias View = AuthViewController
    
    weak var viewController: View!
    
    required init(viewController: AuthViewController) {
        self.viewController = viewController
    }
    
}
