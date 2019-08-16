//
//  EditAccountDetailsViewController.swift
//  Bold
//
//  Created by Admin on 8/16/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

protocol EditAccountDetailsViewControllerDelegate: class {
    func item(_ item: AccountDetailsItem, didChangeValue to: String?)
}

class EditAccountDetailsViewController: UIViewController {
    weak var delegate: EditAccountDetailsViewControllerDelegate?
    var item: AccountDetailsItem?
    var value: String?
    
    @IBOutlet private weak var itemNameLabel: UILabel!
    @IBOutlet private weak var itemValueTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        configureNavigationBar()
        configureSubviews()
    }
    
    private func configureNavigationBar() {
        navigationItem.titleView = prepareTitleView()
        let leftBarButtonItem = UIBarButtonItem(image: Asset.arrowBack.image,
                                                style: .plain, target: self, action: #selector(didTapAtBackBarButtonItem(_:)))
        navigationItem.setLeftBarButton(leftBarButtonItem, animated: true)
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.4745098039, green: 0.5568627451, blue: 0.8509803922, alpha: 1)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    private func configureSubviews() {
        itemNameLabel.text = item?.rawValue
        itemValueTextField.text = value
    }
    
    private func prepareTitleView() -> UILabel {
        let label = UILabel()
        label.font = FontFamily.MontserratMedium.regular.font(size: 16.5)
        label.textColor = #colorLiteral(red: 0.08235294118, green: 0.09803921569, blue: 0.4156862745, alpha: 1)
        label.textAlignment = .center
        label.text = "Edit " + (item?.rawValue.lowercased() ?? "")
        return label
    }
    
    @IBAction private func textFieldEditingChanged(_ sender: UITextField) {
    }
    
    @IBAction private func confirmButtonTapped(_ sender: UIButton) {
        if let item = item {
            delegate?.item(item, didChangeValue: itemValueTextField.text)
        }
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction private func cancelButtonTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func didTapAtBackBarButtonItem(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
}
