//
//  DownloadsRouter.swift
//  Bold
//
//  Created by Alexander Kovalov on 8/27/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation

enum DownloadsRouterInput {
    case close
}

protocol DownloadsRouterInputProtocol: RouterProtocol {
    func input(_ inputCase: DownloadsRouterInput)
}

class DownloadsRouter: DownloadsRouterInputProtocol {
    
    typealias View = DownloadsViewController
    
    weak var viewController: View!
    
    required init(viewController: View) {
        self.viewController = viewController
    }
    
    func input(_ inputCase: DownloadsRouterInput) {
        switch inputCase {
        case .close:
            viewController.navigationController?.popViewController(animated: true)
        }
    }
    
}
