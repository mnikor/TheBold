//
//  ShapeButton.swift
//  BuduSushiDev
//
//  Created by branderstudio on 9/4/18.
//  Copyright © 2018 branderstudio. All rights reserved.
//

import UIKit

class ShapeButton: UIButton {
    
    // MARK: - UI elements
    
    private let formShapeLayer = CAShapeLayer()
    
    // MARK: - Public variables
    
    override var isEnabled: Bool {
        didSet {
            if isEnabled {
                updateForEnabled()
            } else {
                updateForDisabled()
            }
        }
    }
    
    override var backgroundColor: UIColor? {
        set {
            formShapeLayer.fillColor = newValue?.cgColor
        }
        get {
            guard let cgColor = formShapeLayer.fillColor else { return nil }
            return UIColor(cgColor: cgColor)
        }
    }
    
    // MARK: - Life cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initConfigure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initConfigure()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutFormShapeLayer()
    }
    
    // MARK: - Init configure
    
    private func initConfigure() {
        layer.insertSublayer(formShapeLayer, at: 0)
    }

    func layoutFormShapeLayer() {
        
        let leftRightCurvesMaxHeight: CGFloat = 0.5
        let topBottomCurvesMaxHeight: CGFloat = 2.7
        let cornerSize: CGFloat = 10
        
        let pointA = CGPoint(x: leftRightCurvesMaxHeight, y: topBottomCurvesMaxHeight + cornerSize)
        let pointB = CGPoint(x: leftRightCurvesMaxHeight + cornerSize, y: topBottomCurvesMaxHeight)
        let controlPointAB = CGPoint(x: leftRightCurvesMaxHeight, y: topBottomCurvesMaxHeight)
        let pointC = CGPoint(x: bounds.width - (leftRightCurvesMaxHeight + cornerSize), y: topBottomCurvesMaxHeight)
        let controlPointBC = CGPoint(x: bounds.width / 2, y: 0 - topBottomCurvesMaxHeight)
        let pointD = CGPoint(x: bounds.width - leftRightCurvesMaxHeight, y: topBottomCurvesMaxHeight + cornerSize)
        let controlPointCD = CGPoint(x: bounds.width - leftRightCurvesMaxHeight, y: topBottomCurvesMaxHeight)
        let pointE = CGPoint(x: bounds.width - leftRightCurvesMaxHeight, y: bounds.height - (topBottomCurvesMaxHeight + cornerSize))
        let controlPointDE = CGPoint(x: bounds.width + leftRightCurvesMaxHeight, y: bounds.height / 2)
        let pointF = CGPoint(x: bounds.width - (leftRightCurvesMaxHeight + cornerSize), y: bounds.height - topBottomCurvesMaxHeight)
        let controlPointEF = CGPoint(x: bounds.width - leftRightCurvesMaxHeight, y: bounds.height - topBottomCurvesMaxHeight)
        let pointG = CGPoint(x: leftRightCurvesMaxHeight + cornerSize, y: bounds.height - topBottomCurvesMaxHeight)
        let controlPointFG = CGPoint(x: bounds.width / 2, y: bounds.height + topBottomCurvesMaxHeight)
        let pointH = CGPoint(x: leftRightCurvesMaxHeight, y: bounds.height - (topBottomCurvesMaxHeight + cornerSize))
        let controlPointGH = CGPoint(x: leftRightCurvesMaxHeight, y: bounds.height - topBottomCurvesMaxHeight)
        let controlPointHA = CGPoint(x: 0 - leftRightCurvesMaxHeight, y: bounds.height / 2)
        
        let formPath = UIBezierPath()
        formPath.move(to: pointA)
        formPath.addQuadCurve(to: pointB, controlPoint: controlPointAB)
        formPath.addQuadCurve(to: pointC, controlPoint: controlPointBC)
        formPath.addQuadCurve(to: pointD, controlPoint: controlPointCD)
        formPath.addQuadCurve(to: pointE, controlPoint: controlPointDE)
        formPath.addQuadCurve(to: pointF, controlPoint: controlPointEF)
        formPath.addQuadCurve(to: pointG, controlPoint: controlPointFG)
        formPath.addQuadCurve(to: pointH, controlPoint: controlPointGH)
        formPath.addQuadCurve(to: pointA, controlPoint: controlPointHA)
        formPath.close()
        
        formShapeLayer.path = formPath.cgPath
    }
    
    // MARK: - Private
    
    private func updateForEnabled() {
        backgroundColor = UIConstants.Enabled.color
        setTextColor(UIConstants.Enabled.textColor)
    }
    
    private func updateForDisabled() {
        backgroundColor = UIConstants.Disabled.color
        setTextColor(UIConstants.Disabled.textColor)
    }
    
    // MARK: - UI constants
    
    private struct UIConstants {
        
        struct Enabled {
            static let color: UIColor = UIColor(red: 231/255, green: 78/255, blue: 27/255, alpha: 1)
            static let textColor: UIColor = .white
        }
        
        struct Disabled {
            static let color: UIColor = UIColor(red: 63/255, green: 63/255, blue: 63/255, alpha: 1)
            static let textColor: UIColor = UIColor.white.withAlphaComponent(0.5)
        }
        
    }
}
