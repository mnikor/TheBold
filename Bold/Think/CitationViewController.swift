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

class CitationViewController: UIViewController, AlertDisplayable {

    @IBOutlet weak var authorImageView: CustomImageView!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var citationTextLabel: UILabel!
    
    @IBAction func tapShareButton(_ sender: UIButton) {
        configureShareActivity()
    }
    
    var alertController: BlurAlertController?
    
    var quote: ActivityContent?
    var color: ColorGoalType = .none
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = color.colorGoal()
        configure()
    }
    
    func configure() {
        authorImageView.cornerRadius = authorImageView.bounds.size.height / 2
        authorImageView.image = nil
        authorImageView.backgroundColor = .white
        
        authorNameLabel.text = quote?.authorName
        authorImageView.downloadImageAnimated(path: quote?.authorPhotoURL ?? "")
        //authorImageView.setImageAnimated(path: quote?.authorPhotoURL ?? "")
        citationTextLabel.text = quote?.body
    }
    
    func configureShareActivity() {
        let shareView = RateAndShareView.loadFromNib()
        shareView.delegate = self
        
        guard let image = authorImageView.image, let authorName = quote?.authorName, let citation = quote?.body else { return }
        
        shareView.configureCitation(authorImage: image,
                                    authorName: authorName,
                                    citation: citation,
                                    color: color.colorGoal())
        
        alertController = showAlert(with: shareView)
    }

}

extension CitationViewController: RateAndShareViewDelegate {
    func rateUs() {
        
    }
    
    func share(with image: UIImage, actionType: String) {
        let title = GlobalConstants.appURL
        let image = image
        let appLink = URL(string: GlobalConstants.appURL)!
        
        let items: [Any] = [title, image, appLink]
        
        alertController?.shareContent(with: items)
    }
}
