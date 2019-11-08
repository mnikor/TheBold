//
//  ProgressHeaderView.swift
//  Bold
//
//  Created by Alexander Kovalov on 6/26/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ProgressHeaderView: UIView {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var pointsImageView: UIImageView!
    
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
        Bundle.main.loadNibNamed("ProgressHeaderView", owner: self)
        contentView.fixInView(self)
        backgroundColor = .clear
        config()
    }
    
    func config() {
        pointsImageView.image = Asset.feelShape.image
        
        LevelOfMasteryService.shared.changePoints.subscribe(onNext: {[weak self] (levelInfo) in
             
            self?.titleLabel.text = levelInfo.level.type.titleText
            self?.pointsLabel.text = "\(levelInfo.currentPoint)"
            self?.progressView.progress = Float(levelInfo.currentPoint)/Float(levelInfo.level.limits.first!.points)
         
        }).disposed(by: disposeBag)
    }

}
