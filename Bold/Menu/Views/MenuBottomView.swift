//
//  MenuBottomView.swift
//  Bold
//
//  Created by Alexander Kovalov on 6/11/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

enum MenuBottomViewType {
    case user
    case logIn
}

protocol MenuBottomViewDelegate: class {
    func tapShowUsetProfile()
    func tapShowLogIn()
}

class MenuBottomView: UIView {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!

    weak var delegate: MenuBottomViewDelegate?
    var typeView: MenuBottomViewType? = .user
    
    let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("MenuBottomView", owner: self)
        contentView.fixInView(self)
        backgroundColor = .clear
        subscribeUpdateLevel()
    }
    
    func config(type: MenuBottomViewType) {
        userImageView.isHidden = type == .logIn
    }
    
    func setName(_ name: String?) {
        titleLabel.text = name
    }
    
    func setLevel(_ level: String?) {
        subtitleLabel.text = level
    }
    
    private func subscribeUpdateLevel() {
        LevelOfMasteryService.shared.changePoints.subscribe(onNext: {[weak self] (levelInfo) in
            self?.subtitleLabel.text = levelInfo.level.type.titleText
        }).disposed(by: disposeBag)
    }
    
    @IBAction func tapBottomView(_ sender: UIButton) {
        guard let typeView = typeView else {
            return
        }
        switch typeView {
        case .logIn:
            delegate?.tapShowLogIn()
        case .user:
            delegate?.tapShowUsetProfile()
        }
    }
}
