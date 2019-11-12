//
//  HeaderHomeView.swift
//  Bold
//
//  Created by Alexander Kovalov on 6/12/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class HeaderHomeView: UIView {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var yourProgressLabel: UILabel!
    @IBOutlet weak var levelNameLabel: UILabel!
    @IBOutlet weak var masteryLabel: UILabel!
    @IBOutlet weak var currentPointsLabel: UILabel!
    @IBOutlet weak var iconPointImageView: UIImageView!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var boldnessLabel: UILabel!
    
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
        Bundle.main.loadNibNamed("HeaderHomeView", owner: self)
        self.translatesAutoresizingMaskIntoConstraints = false
        contentView.frame = self.frame;
        self.addSubview(contentView)
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        //contentView.fixInView(self)
        
        configure()
    }
    
    func setName(_ name: String?) {
        if let name = name {
            welcomeLabel.text = "Welcome back,"
            usernameLabel.text = name + "!"
        } else {
            welcomeLabel.text = "Welcome back!"
            usernameLabel.text = nil
        }
    }
    
    func configure() {
        
       LevelOfMasteryService.shared.changePoints.subscribe(onNext: {[weak self] (levelInfo) in
            
        self?.levelNameLabel.text = levelInfo.level.type.titleText
        let currentLimits = levelInfo.level.limits.getAllLimits()
        self?.currentPointsLabel.text = "\(levelInfo.currentPoint)/\(currentLimits.points)"
        
       }).disposed(by: disposeBag)
    }
    
}
