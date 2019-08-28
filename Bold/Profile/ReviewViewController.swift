//
//  ReviewViewController.swift
//  Bold
//
//  Created by Alexander Kovalov on 8/23/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit
import Cosmos

class ReviewViewController: UIViewController {

    @IBOutlet weak var rateView: CosmosView!
    @IBOutlet weak var tapStarLabel: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var descriptionTextView: FixedPaddingTextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()
        configElements()
    }
    
    private func configElements() {
        tapStarLabel.text = L10n.Profile.Review.tapStarToRateIt
        titleTextField.delegate = self
        descriptionTextView.delegate = self
        titleTextField.placeholder = L10n.Profile.Review.title
        descriptionLabel.text = L10n.Profile.Review.descriptionOptional
        
        rateView.didFinishTouchingCosmos = didFinishTouchingCosmos
    }

    private func configureNavigationBar() {
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationItem.titleView = prepareTitleView()
        let leftBarButtonItem = UIBarButtonItem(title: L10n.cancel, style: .plain, target: self, action: #selector(didTapAtBackBarButtonItem(_:)))
        let rightBarButtonItem = UIBarButtonItem(title: L10n.Profile.Review.send, style: .plain, target: self, action: #selector(didTapSendBarButtonItem(_:)))
        navigationItem.setLeftBarButton(leftBarButtonItem, animated: true)
        navigationItem.setRightBarButton(rightBarButtonItem, animated: true)
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.4745098039, green: 0.5568627451, blue: 0.8509803922, alpha: 1)
    }
    
    private func prepareTitleView() -> UILabel {
        let label = UILabel()
        label.font = FontFamily.MontserratMedium.regular.font(size: 17)
        label.textColor = #colorLiteral(red: 0.3450980392, green: 0.3607843137, blue: 0.4156862745, alpha: 1)
        label.textAlignment = .center
        label.text = L10n.Profile.review
        return label
    }
    
    @objc private func didTapAtBackBarButtonItem(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func didTapSendBarButtonItem(_ sender: UIBarButtonItem) {
        
    }
    
    private func didFinishTouchingCosmos(_ rating: Double) {
        print("Rating = \(rating)")
    }

}

extension ReviewViewController: UITextFieldDelegate {
    
    
    
}

extension ReviewViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        
        descriptionLabel.isHidden = !textView.text.isEmpty
        
    }
    
}
