//
//  CreateActionRouter.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/23/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation
import UIKit
import MessageUI

enum CreateActionInputRouter {
    case presentSetting(AddActionCellType)
    case stake
    case share
    case cancel
    case systemShareAction([Any])
    case shareByEmail(UIImage, String, String)
}

protocol CreateActionInputRouterProtocol {
    func input(_ inputCase: CreateActionInputRouter)
}

class CreateActionRouter: RouterProtocol, CreateActionInputRouterProtocol {
    
    typealias View = CreateActionViewController
    
    weak var viewController: View!
 
    required init(viewController: View) {
        self.viewController = viewController
    }
    
    func input(_ inputCase: CreateActionInputRouter) {
        switch inputCase {
        case .presentSetting(let type):
            viewController.performSegue(withIdentifier: StoryboardSegue.Act.configurateActionIdentifier.rawValue, sender: type)
        case .stake:
            viewController.performSegue(withIdentifier: StoryboardSegue.Act.stakeIdentifier.rawValue, sender: nil)
        case .share:
            viewController.performSegue(withIdentifier: StoryboardSegue.Act.shareWithFriendsIdentifier.rawValue, sender: nil)
        case .cancel:
            viewController.navigationController?.popViewController(animated: true)
        case .systemShareAction(let items):
            viewController.alertController?.shareContent(with: items)
        case .shareByEmail(let image, let link, let title):
            configureShareEmail(with: image, and: link, title: title)
        }
    }
    
    func configureShareEmail(with image: UIImage, and link: String, title: String) {
        
        if !MFMailComposeViewController.canSendMail() { return }
        
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = viewController
        composeVC.setSubject(title)
        
        if let imageData = image.jpegData(compressionQuality: 1) {
            composeVC.addAttachmentData(imageData, mimeType: "image/jpeg", fileName: "\(title).jpeg")
        }
        
        let appLink = GlobalConstants.appURL
        
        composeVC.setMessageBody("<html><body><p>\(appLink)</p></body></html>", isHTML: true)
        
        viewController.alertController?.present(composeVC, animated: true, completion: nil)
        
    }

}
