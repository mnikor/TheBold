//
//  AlertDisplayable.swift
//  BuduSushiDev
//
//  Created by branderstudio on 9/19/18.
//  Copyright © 2018 branderstudio. All rights reserved.
//

import UIKit

protocol AlertDisplayable: class {
    func showAlert(with view: UIView, completion: (() -> Void)?) -> BlurAlertController
}

extension AlertDisplayable where Self: UIViewController {
    func showAlert(with view: UIView, completion: (() -> Void)? = nil) -> BlurAlertController {
        let contentView = AlertContentView()
        contentView.containerView = view
        let blurAlertController = createAlertViewController(contentView: contentView)
        let navigationController = UINavigationController(rootViewController: blurAlertController)
        navigationController.navigationBar.isHidden = true
        navigationController.modalPresentationStyle = .overFullScreen
        if let tabBarController = tabBarController {
            if let _ = tabBarController.presentedViewController {
                dismiss(animated: true)
            }
            tabBarController.present(navigationController,
                                     animated: false,
                                     completion: completion)
        } else {
            if let _ = presentedViewController {
                dismiss(animated: true)
            }
            present(navigationController, animated: false, completion: completion)
        }
        return blurAlertController
    }
    
    private func createAlertViewController(contentView: BaseContentView) -> BlurAlertController {
        let blurAlertView = BlurAlertView(contentView: contentView)
        let blurAlertController = BlurAlertController(blurAlertView: blurAlertView)
        return blurAlertController
    }
    
}
