//
//  ProfileRouter.swift
//  Bold
//
//  Created by Admin on 8/14/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

enum ProfileRouterInput {
    case performSegue(segueType: StoryboardSegue.Profile)
    case logout
}

protocol ProfileRouterInputProtocol: RouterProtocol {
    func input(_ inputCase: ProfileRouterInput)
}

class ProfileRouter: ProfileRouterInputProtocol {
    typealias View = ProfileViewController
    
    weak var viewController: View!
    
    required init(viewController: View) {
        self.viewController = viewController
    }
    
    func input(_ inputCase: ProfileRouterInput) {
        switch inputCase {
        case .performSegue(segueType: let segue):
            viewController.perform(segue: segue, sender: nil)
        case .logout:
            guard let viewController = StoryboardScene.Splash.storyboard.instantiateInitialViewController()
                else { return }
            UIApplication.setRootView(viewController,
                                      animated: true)
        }
    }
    
}
