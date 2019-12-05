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
    private var boldnessEndValue = 45
    private var startDate = Date()
    private var animationDuration = 0.8
    private var pointsLimit = 300
    
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
        if UserDefaults.standard.bool(forKey: "first entrance") {
            welcomeLabel.text = "Welcome"
            UserDefaults.standard.setValue(false, forKey: "first entrance")
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
    
    func set(points: Int, boldness: Int) {
        pointsStartValue = Int(currentPointsLabel.text?.components(separatedBy: "/").first ?? "0") ?? 0
        boldnessStartValue = Int(timeLabel.text?.components(separatedBy: "min").first ?? "0" ) ?? 0
        
        pointsEndValue = points
        boldnessEndValue = boldness
        
        let displayLink = CADisplayLink(target: self, selector: #selector(animateValues))
        displayLink.add(to: .main, forMode: .default)
        startDate = Date()
    }
    
    func configure() {
        configureTitle()
        
       LevelOfMasteryService.shared.changePoints.subscribe(onNext: {[weak self] (levelInfo) in
            
        self?.levelNameLabel.text = levelInfo.level.type.titleText
        let currentLimits = levelInfo.level.limits.getAllLimits()
        self?.currentPointsLabel.text = "\(levelInfo.currentPoint)/\(currentLimits.points)"
        self?.pointsLimit = currentLimits.points
        
       }).disposed(by: disposeBag)
    }
    
    @objc private func animateValues() {
        let timeInterval = Date().timeIntervalSince(startDate)
        guard timeInterval < animationDuration
            else {
                currentPointsLabel.text = "\(pointsEndValue)/\(pointsLimit)"
                timeLabel.text = "\(boldnessEndValue)min"
                return
        }
        let percentage = timeInterval / animationDuration
        let pointsNewValue = Double(pointsEndValue - pointsStartValue) * percentage
        let boldnessNewValue = Double(boldnessEndValue - boldnessStartValue) * percentage
        currentPointsLabel.text = "\(Int(pointsNewValue))/\(pointsLimit)"
        timeLabel.text = "\(Int(boldnessNewValue))min"
    }
    
}
