//
//  ManifestRouter.swift
//  Bold
//
//  Created by Alexander Kovalov on 6/21/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation

enum ManifestInput {
    case close
}

protocol ManifestInputRouterProtocol: RouterProtocol {
    func input(_ inputCase: ManifestInput)
}

class ManifestRouter: RouterProtocol, ManifestInputRouterProtocol {
    
    typealias View = ManifestViewController
    
    weak var viewController: View!
    
    required init(viewController: ManifestViewController) {
        
        self.viewController = viewController
    }
    
    func input(_ inputCase: ManifestInput) {
        switch inputCase {
        case .close:
//            viewController.navigationController?.isNavigationBarHidden = false
//            viewController.navigationController?.popViewController(animated: true)
            viewController.dismiss(animated: true, completion: nil)
        }
    }
}
