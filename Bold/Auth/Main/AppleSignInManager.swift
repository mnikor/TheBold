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
    
    var completion: ((String, String) -> ())?
    
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
            
                let user = appleIDCredential.user
                
                let _ = appleIDCredential.identityToken
                
                let _ = appleIDCredential.fullName
                
                if let email = appleIDCredential.email {
                    completion?(user, email) }

            default: break
            
        }
        
    }
    
}
