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
    
    @IBOutlet weak var changePointLabel: UILabel!
    @IBOutlet weak var changePointView: UIView!
    
    @IBOutlet weak var shadowView: UIView!
    
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
        
        changePointView.cornerRadius = changePointView.bounds.height / 2
        changePointView.isHidden = true
        
        LevelOfMasteryService.shared.changePoints.subscribe(onNext: {[weak self] (levelInfo) in
            self?.titleLabel.text = levelInfo.level.type.titleText
            self?.set(points: levelInfo.currentPoint, changePoint: levelInfo.stepChangePoint, currentLevel: levelInfo.level )
         
        }).disposed(by: disposeBag)
        
        configDisplayLink()
        
        setupGradient()
    }
    
    private func changeCountPoints(points: Int) {
        
        if points > 0 {
            changePointView.backgroundColor = ColorName.secondaryTurquoise.color
            changePointLabel.text = String(format: "+%d", points)
        }else {
            changePointView.backgroundColor = ColorName.primaryRed.color
            changePointLabel.text = String(format: "%d", points)
        }
        
        UIView.transition(with: changePointView, duration: animationDuration, options: [.transitionCrossDissolve, .autoreverse, .curveEaseOut], animations: { [weak self] in
            self?.changePointView.isHidden = false
        }) { (finish) in
            self.changePointView.isHidden = finish
        }
    }
    
    private func configDisplayLink() {
        displayLink = CADisplayLink(target: self, selector: #selector(animateValues))
        displayLink.add(to: .main, forMode: .default)
    }
    
    private func set(points: Int, changePoint: Int, currentLevel: LevelBold) {
        
        if (self.window == nil) {
            pointsLabel.text = "\(points)"
            progressView.progress = Float(points) / Float(Double(currentLevel.limits.getAllLimits().points))
            return
        }
        
        pointsStartValue = points - changePoint
        pointsEndValue = points
        self.changeCountPoints(points: changePoint)
        startDate = Date()
    }
    
    @objc private func animateValues() {
        guard pointsStartValue != pointsEndValue else { return }
        
        let timeInterval = Date().timeIntervalSince(startDate)
        if timeInterval > animationDuration {
            pointsLabel.text = "\(pointsEndValue)"
//            progressView.progress = Float(pointsEndValue) / Float(LevelType.allCases.compactMap({ $0.limits.getAllLimits().points }).first(where: { Int($0) > pointsEndValue }) ?? 1)
            return
        }
        let percentage = timeInterval / animationDuration
        let currentPoints = Double(pointsStartValue) + (percentage * Double(pointsEndValue - pointsStartValue))
        
        progressView.progress = Float(currentPoints) / Float(LevelOfMasteryService.shared.closedLevels.compactMap({ $0.limits.getAllLimits().points }).sorted().first(where: { Double($0) > currentPoints }) ?? 1)
        pointsLabel.text = "\(Int(currentPoints))"
    }
    
    private func setupGradient() {
        let gradientBackgroundColors = [UIColor.lightGray.cgColor, UIColor.white.cgColor] as [Any]
        let gradientLocations: [NSNumber] = [0.0,1.0]

        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientBackgroundColors
        gradientLayer.locations = gradientLocations

        gradientLayer.frame = CGRect(x: shadowView.frame.origin.x,
                                     y: shadowView.frame.origin.y - 2,
                                     width: UIScreen.main.bounds.width,
                                     height: 5)
        shadowView.layer.insertSublayer(gradientLayer, at: 0)
    }

}
