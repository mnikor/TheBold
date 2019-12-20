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
    
    private var pointsStartValue = 0
    private var pointsEndValue = 100
    private var boldnessStartValue = 0
    private var boldnessEndValue = 0
    private var pointsStartDate = Date()
    private var boldnessStartDate = Date()
    private var animationDuration = 0.8
    private var pointsLimit = LevelType.allCases.first?.limits.getAllLimits().points ?? 0
    
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
    
    func configureTitle() {
        if SettingsService.shared.firstEntrance {
            welcomeLabel.text = "Welcome"
            SettingsService.shared.firstEntrance = false
        } else {
            welcomeLabel.text = "Welcome back"
        }
        
        if let profile = SessionManager.shared.profile {
            welcomeLabel.text = (welcomeLabel.text ?? "") + "\(profile.firstName == nil ? "!" : ",")"
            usernameLabel.text = profile.firstName == nil ? "" : "\(profile.firstName ?? "")!"
        } else {
            welcomeLabel.text = (welcomeLabel.text ?? "")
            usernameLabel.text = "Bold Man!"
        }
    }
    
    func set(points: Int) {
        pointsStartValue = Int(currentPointsLabel.text?.components(separatedBy: "/").first ?? "0") ?? 0
        pointsEndValue = points
        
        let displayLink = CADisplayLink(target: self, selector: #selector(animatePoints))
        displayLink.add(to: .main, forMode: .default)
        pointsStartDate = Date()
    }
    
    func setBoldness(boldness: Int) {
        boldnessStartValue = Int(timeLabel.text?.components(separatedBy: "min").first ?? "0" ) ?? 0
        boldnessEndValue = boldness
        
        let displayLink = CADisplayLink(target: self, selector: #selector(animateBoldness))
        displayLink.add(to: .main, forMode: .default)
        pointsStartDate = Date()
    }
    
    func configure() {
        configureTitle()
        
       LevelOfMasteryService.shared.changePoints.subscribe(onNext: {[weak self] (levelInfo) in
            
        self?.levelNameLabel.text = levelInfo.level.type.titleText
        let currentLimits = levelInfo.level.limits.getAllLimits()
        self?.pointsLimit = currentLimits.points
        self?.set(points: levelInfo.currentPoint)
       }).disposed(by: disposeBag)
    }
    
    @objc private func animatePoints() {
        let timeInterval = Date().timeIntervalSince(pointsStartDate)
        guard timeInterval < animationDuration
            else {
                currentPointsLabel.text = "\(pointsEndValue)/\(pointsLimit)"
                timeLabel.text = "\(boldnessEndValue)min"
                return
        }
        let percentage = timeInterval / animationDuration
        let pointsNewValue = Double(pointsEndValue - pointsStartValue) * percentage
        pointsLimit = LevelType.allCases.compactMap({ $0.limits.getAllLimits().points }).first(where: { $0 > Int(pointsNewValue) }) ?? 0
        currentPointsLabel.text = "\(Int(pointsNewValue))/\(pointsLimit)"
    }
    
    @objc private func animateBoldness() {
        let timeInterval = Date().timeIntervalSince(boldnessStartDate)
        guard timeInterval < animationDuration
            else {
                timeLabel.text = "\(boldnessEndValue)min"
                return
        }
        let percentage = timeInterval / animationDuration
        let boldnessNewValue = Double(boldnessEndValue - boldnessStartValue) * percentage
        timeLabel.text = "\(Int(boldnessNewValue))min"
    }
    
}
