//
//  CitationViewController.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/9/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

enum CitationType {
    case orange
    case blue
    case ink
    
    func backgroundcolor() -> Color {
        switch self {
        case .orange:
            return ColorName.primaryOrange.color
        case .blue:
            return ColorName.primaryBlue.color
        case .ink:
            return ColorName.typographyBlack100.color
        }
    }
}

class CitationViewController: UIViewController {

    @IBOutlet weak var authorImageView: UIImageView!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var citationTextLabel: UILabel!
    
    @IBAction func tapShareButton(_ sender: UIButton) {
        print("Share Citate")
        self.shareContent(item: nil)
    }
    
    var type: CitationType = .orange
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = type.backgroundcolor()
    }

}
