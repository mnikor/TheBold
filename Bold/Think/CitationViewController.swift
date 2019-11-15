//
//  CitationViewController.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/9/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

enum CitationType: Int {
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
    
    static func randomColor() -> Color {
        let value = Int.random(in: (0 ... 101)) % 3
        return CitationType(rawValue: value)?.backgroundcolor() ??  ColorName.typographyBlack100.color
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
    
    var quote: ActivityContent?
    var color: ColorGoalType = .none
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = color.colorGoal()
        configure()
    }
    
    func configure() {
        authorNameLabel.text = quote?.authorName
        authorImageView.setImageAnimated(path: quote?.imageURL ?? "")
        citationTextLabel.text = quote?.body
    }

}
