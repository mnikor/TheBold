//
//  FeelRouter.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/22/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

enum FeelInputRouter {
    case menuShow
    case showAll(FeelTypeCell)
    case showPlayer(isPlaying: Bool, isDownloadedContent: Bool, content: ActivityContent?)
    case present(UIViewController)
}

protocol FeelInputRouterProtocol {
    func input(_ inputCase: FeelInputRouter)
}

class FeelRouter: RouterProtocol, FeelInputRouterProtocol {
    
    typealias View = FeelViewController
    
    weak var viewController: FeelViewController!
    
    required init(viewController: View) {
        self.viewController = viewController
    }
    
    func input(_ inputCase: FeelInputRouter) {
        
        switch inputCase {
        case .menuShow:
            viewController.showSideMenu()
        case .showAll(let typeCell):
            viewController.performSegue(withIdentifier: StoryboardSegue.Feel.showItem.rawValue, sender: typeCell)
        case .showPlayer(isPlaying: let isPlaying, isDownloadedContent: let isDownloadedContent, let content):
            PlayerViewController.createController(content: content)
        case .present(let vc):
            if let topVC = UIApplication.topViewController {
                topVC.present(vc, animated: true)
            } else {
                viewController.navigationController?.present(vc, animated: true)
            }
        }
    }
}
