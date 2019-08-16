//
//  ButtonedTitleCell.swift
//  Bold
//
//  Created by Admin on 8/15/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

protocol ButtonedTitleCellDelegate: class {
    func buttonedTitleCellDidTapAtButton(_ cell: ButtonedTitleCell)
}

class ButtonedTitleCell: UITableViewCell, Reusable {
    weak var delegate: ButtonedTitleCellDelegate?
    
    private let label: UILabel = {
        let label = UILabel()
        label.setContentHuggingPriority(.required, for: .vertical)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.font = FontFamily.Montserrat.regular.font(size: 15)
        return label
    }()
    
    private let button: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = FontFamily.Montserrat.regular.font(size: 14.5)
        button.setTitleColor(#colorLiteral(red: 0.231372549, green: 0.3411764706, blue: 0.768627451, alpha: 1), for: .normal)
        button.titleLabel?.textColor = #colorLiteral(red: 0.231372549, green: 0.3411764706, blue: 0.768627451, alpha: 1)
        button.setContentHuggingPriority(.required, for: .horizontal)
        button.setContentCompressionResistancePriority(.required, for: .horizontal)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    private func configure() {
        configureLabel()
        configureButton()
    }
    
    private func configureLabel() {
        addSubview(label)
        label.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(17)
            make.leading.equalToSuperview().offset(26)
            make.centerY.equalToSuperview()
        }
    }
    
    private func configureButton() {
        addSubview(button)
        button.snp.makeConstraints { make in
            make.leading.equalTo(label.snp.trailing).offset(15)
            make.trailing.equalToSuperview().inset(26)
            make.centerY.equalToSuperview()
        }
        button.addTarget(self, action: #selector(didTapAtButton(_:)), for: .touchUpInside)
    }
    
    @objc private func didTapAtButton(_ sender: UIButton) {
        delegate?.buttonedTitleCellDidTapAtButton(self)
    }
    
    func configure(with viewModel: ButtonedTitleViewModel) {
        label.text = viewModel.title
        button.setTitle(viewModel.buttonTitle, for: .normal)
    }
    
}
