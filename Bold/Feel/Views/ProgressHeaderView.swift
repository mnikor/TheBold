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
    
    private var displayLink = CADisplayLink()
    private var pointsStartValue = 0
    private var pointsEndValue = 0
    private var progressStartValue: Float = 0
    private var progressEndValue: Float = 0
    private var startDate = Date()
    private let animationDuration = 1.5
    
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
            self?.set(points: levelInfo.currentPoint, progress: Float(levelInfo.level.completionPercentage) / 100)
//            self?.pointsLabel.text = "\(levelInfo.currentPoint)"
//            self?.progressView.progress = Float(levelInfo.level.completionPercentage) / 100
         
        }).disposed(by: disposeBag)
        
        configDisplayLink()
    }
    
    func configDisplayLink() {
        displayLink = CADisplayLink(target: self, selector: #selector(animateValues))
        displayLink.add(to: .main, forMode: .default)
    }
    
    func set(points: Int, progress: Float) {
        pointsStartValue = Int(pointsLabel.text ?? "") ?? 0
        pointsEndValue = points
        progressStartValue = progressView.progress
        progressEndValue = progress
        startDate = Date()
    }
    
    @objc private func animateValues() {
        guard pointsStartValue != pointsEndValue else { return }
        
        let timeInterval = Date().timeIntervalSince(startDate)
        if timeInterval > animationDuration {
            pointsLabel.text = "\(pointsEndValue)"
            progressView.progress = progressEndValue
            return
        }
        let percentage = timeInterval / animationDuration
        let currentPoints = Double(pointsStartValue) + (percentage * Double(pointsEndValue - pointsStartValue))
        progressView.progress = progressStartValue + (Float(percentage) * (progressEndValue - progressStartValue))
        pointsLabel.text = "\(Int(currentPoints))"
    }

}
