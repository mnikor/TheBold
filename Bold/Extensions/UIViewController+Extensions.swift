//
//  UIViewController+Extensions.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/19/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func shareContent(item: Any?) {
        let text = "Share"
        let activityVC = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        present(activityVC, animated: true, completion: nil)
    }
    
    func shareContent(with items: [Any]) {
        let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
    }
    
}
