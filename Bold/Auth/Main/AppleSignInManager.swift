//
//  AppleSignInManager.swift
//  Bold
//
//  Created by Denis Grishchenko on 7/13/20.
//  Copyright © 2020 Alexander Kovalov. All rights reserved.
//

import AuthenticationServices

class AppleSignInManager: NSObject {
    
    static let shared = AppleSignInManager()
    
    var completion: (() -> Void)?
    
    func authorizationRequest() {
        
        if #available(iOS 13.0, *) {
            
            let request = ASAuthorizationAppleIDProvider().createRequest()
            
            request.requestedScopes = [.email, .fullName]
            
            let controller = ASAuthorizationController(authorizationRequests: [request])
            
            controller.delegate = self
            
            controller.performRequests()
            
        }
        
    }
    
}

extension AppleSignInManager: ASAuthorizationControllerDelegate {
    
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        switch authorization.credential {
            
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            
            var firstName = ""
            var lastName = ""
            var email = ""
            
            let user = appleIDCredential.user
            
            guard let code = appleIDCredential.authorizationCode?.base64EncodedString() else { return }
            guard  let idToken = appleIDCredential.identityToken?.base64EncodedString() else { return }
            if let fName = appleIDCredential.fullName?.givenName { firstName = fName }
            if let lName = appleIDCredential.fullName?.familyName { lastName = lName }
            
            if let mail = appleIDCredential.email { email = mail }
            
            print("Code: \(code), \nidToken: \(idToken), \nfirstName: \(firstName), lastName: \(lastName), email: \(email), uid: \(user)")
            
            NetworkService.shared.appleSignIn(code: code, idToken: idToken, email: email, user: user, firstName: firstName, lastName: lastName) { [weak self] (result) in
                switch result {
                case .failure(let error):
                    // add error handling
                    print("Auth error: \(error.localizedDescription)")
                    break
                case .success(let profile):
                    SessionManager.shared.profile = profile
                    print("Successfull login")
                    self?.completion?()
                }
            }
        
        default: break
            
        }
        
    }
    
}
