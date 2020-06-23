//
//  AuthViewPresenter.swift
//  Bold
//
//  Created by Denis Grishchenko on 6/23/20.
//  Copyright © 2020 Alexander Kovalov. All rights reserved.
//

import Foundation

protocol AuthViewPresenterInputProtocol: class {
    func didTapSignUp(_ type: TypeAuthView, email: String?, password: String?, name: String?, acceptTerms: Bool?)
}

protocol AuthViewPresenterOutputProtocol: class {
    func moveToHomeView(controller: HostViewController)
    func showAlert(title: String, message: String)
}

class AuthViewPresenter: PresenterProtocol, AuthViewPresenterInputProtocol, AuthViewPresenterOutputProtocol {
    
    // MARK: - PRESENTER PROTOCOL -
    
    typealias View = AuthViewControllerInputProtocol
    typealias Interactor = AuthViewInteractorInputProtocol
    typealias Router = AuthViewRouterInputProtocol
 
    weak var viewController: View!
    var interactor: Interactor!
    var router: Router!
    
    // MARK: - INIT
    
    required init(view: AuthViewControllerInputProtocol) {
        viewController = view
    }
    
    required init?(coder aDecoder: NSCoder) {}
    
    // MARK: - INPUT PROTOCOL
    
    func didTapSignUp(_ type: TypeAuthView, email: String?, password: String?, name: String?, acceptTerms: Bool?) {
        
        switch type {
            
        case .logIn:
            interactor.login(email: email, password: password)
            
        case .signUp:
            interactor.signUp(acceptTerms: acceptTerms, name: name, email: email, password: password)
        }
    }
    
    // MARK: - OUTPUT PROTOCOL
    
    func moveToHomeView(controller: HostViewController) {
        viewController.setRootController(controller)
    }
    
    func showAlert(title: String, message: String) {
        viewController.showAlert(title: title, message: message)
    }
}
