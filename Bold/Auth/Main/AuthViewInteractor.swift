//
//  AuthViewInteractor.swift
//  Bold
//
//  Created by Denis Grishchenko on 6/23/20.
//  Copyright © 2020 Alexander Kovalov. All rights reserved.
//

import Foundation

protocol AuthViewInteractorInputProtocol: class {
    func login(email: String?, password: String?)
    func signUp(acceptTerms: Bool?, name: String?, email: String?, password: String?)
    func signInWithAppleId(completion: @escaping (String, String) -> Void)
}

class AuthViewInteractor: InteractorProtocol, AuthViewInteractorInputProtocol {
    
    // MARK: - PRESENTER
    
    typealias Presenter = AuthViewPresenterOutputProtocol
    
    weak var presenter: Presenter!
    
    var appleManager: AppleSignInManager!
    
    // MARK: - INIT
    
    required init(presenter: AuthViewPresenterOutputProtocol) {
        self.presenter = presenter
    }
    
    convenience init(presenter: AuthViewPresenterOutputProtocol, appleSignInManager: AppleSignInManager) {
        self.init(presenter: presenter)
        appleManager = appleSignInManager
    }
    
    // MARK: - INPUT PROTOCOL
    
    func login(email: String?, password: String?) {
        
        if !checkEmail(email,
                       password: password,
                       name: nil,
                       acceptTerms: nil,
                       isSignUp: false) { return }
        
        NetworkService.shared.login(email: email ?? "",
                                    password: password ?? "") { [weak self] result in
                                        guard let ss = self else { return }
                                        switch result {
                                        case .failure(let error):
                                            // add error handling
                                            break
                                        case .success(let profile):
                                            SessionManager.shared.profile = profile
                                            let vc = StoryboardScene.Menu.initialScene.instantiate()
                                            ss.presenter.moveToHomeView(controller: vc)
                                        }
        }
    }
    
    func signUp(acceptTerms: Bool?, name: String?, email: String?, password: String?) {
        
        if !checkEmail(email,
                       password: password,
                       name: name,
                       acceptTerms: acceptTerms,
                       isSignUp: true) { return }
        
        NetworkService.shared.signUp(firstName: name ?? "",
                                     lastName: nil,
                                     email: email ?? "",
                                     password: password ?? "",
                                     acceptTerms: acceptTerms ?? false) { [weak self] result in
                                        guard let ss = self else { return }
                                        switch result {
                                        case .failure(let error):
                                            // add error handling
                                            break
                                        case .success(let profile):
                                            SettingsService.shared.firstEntrance = true
                                            SessionManager.shared.profile = profile
                                            let vc = StoryboardScene.Menu.initialScene.instantiate()
                                            ss.presenter.moveToHomeView(controller: vc)
                                        }
        }
        
    }
    
    // MARK: - CHECK EMAIL
    
    private func checkEmail(_ email: String?, password: String?, name: String?, acceptTerms: Bool?, isSignUp: Bool) -> Bool {
        
        if isSignUp {
            guard let name = name, !name.isEmpty else {
                presenter.showAlert(title: "Warning", message: "Please enter your name")
                return false
            }
            
            guard let acceptTerms = acceptTerms, acceptTerms else {
                presenter.showAlert(title: "Warning", message: "Please accept Terms and conditions")
                return false
            }
        }
        
        guard let email = email, !email.isEmpty else {
            presenter.showAlert(title: "Warning", message: "Please enter your email")
            return false
        }
        
        if !email.isValidEmail() {
            presenter.showAlert(title: "Warning", message: "Please enter correct email")
            return false
        }
        
        guard let pass = password, !pass.isEmpty else {
            presenter.showAlert(title: "Warning", message: "Please enter password")
            return false
        }
        
        return true
        
    }
    
    func signInWithAppleId(completion: @escaping (String, String) -> Void) {
        appleManager.authorizationRequest()
        appleManager.completion = { (user, email) in
            completion(user, email)
        }
    }
    
}
