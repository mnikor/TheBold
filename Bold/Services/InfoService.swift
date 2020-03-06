//
//  InfoService.swift
//  Bold
//
//  Created by Alexander Kovalov on 27.02.2020.
//  Copyright © 2020 Alexander Kovalov. All rights reserved.
//

import Foundation
import UIKit

enum InfoTip {
    case stakeCell
    case stakeContentCell
    case goalCell
    
    var descriptionText: String {
        switch self {
        case .stakeCell:
            return L10n.InfoService.tapToViewTaskDetails
        case .stakeContentCell:
            return L10n.InfoService.longTapToViewSelectedContent
        case .goalCell:
            return L10n.InfoService.longTapToEditSelectedGoal
        }
    }
    
    var width: CGFloat {
        return self.descriptionText.widthText(withConstrainedHeight: 30, font: FontFamily.MontserratMedium.regular.font(size: 13))
    }
}

class InfoService: UIViewController {
    
    private var overlayView = UIView()
    private var baseView : UIView!
    private var infoView : UIImageView!
    private var infoType: InfoTip!
    
    private var closeInfoCallBack : VoidCallback?
    
    class func showInfo(type: InfoTip, baseView: UIView, closeInfo: @escaping VoidCallback) {
        let infoVC = InfoService()
        
        infoVC.infoType = type
        infoVC.baseView = baseView
        infoVC.closeInfoCallBack = closeInfo
        
        infoVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        infoVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        
        guard let rootViewController = UIApplication.shared.keyWindow?.rootViewController else { return }
        rootViewController.addChild(infoVC)
        rootViewController.view.addSubview(infoVC.view)
        
        infoVC.view.setNeedsLayout()
        infoVC.view.layoutIfNeeded()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        clicked()
    }
    
    func setup() {
        let tempcolor = baseView.backgroundColor
        baseView.backgroundColor = .white
        infoView = UIImageView(image: baseView.asImage())
        infoView.backgroundColor = .clear
        baseView.backgroundColor = tempcolor
        
        let globalPoint = baseView.superview?.convert(baseView.frame.origin, to: nil)
        infoView.frame.origin = globalPoint!
        
        infoView.alpha = 0
        overlayView.alpha = 0
    }
    
    override func viewWillLayoutSubviews() {
        infoView.topAnchor.constraint(equalTo: view.topAnchor, constant: infoView.frame.origin.y).isActive = true
        infoView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: infoView.frame.origin.x).isActive = true
        infoView.widthAnchor.constraint(equalToConstant: infoView.bounds.size.width).isActive = true
        infoView.heightAnchor.constraint(equalToConstant: infoView.bounds.size.height).isActive = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showAnimateView()
    }
    
     private func clicked() {

        overlayView.fixInView(view)
        overlayView.backgroundColor = Color(red: 22/255, green: 28/255, blue: 52/255, alpha: 1.0)
        view.addSubview(overlayView)
        view.addSubview(infoView)
        
        let vc = UIViewController()
        
        let label = UILabel()
        label.text = infoType.descriptionText
        label.textColor = .white
        label.textAlignment = .center
        label.font = FontFamily.MontserratMedium.regular.font(size: 13)
        label.fixInView(vc.view)
        vc.view.addSubview(label)
        
        vc.view.backgroundColor = .clear
        vc.modalPresentationStyle = .popover
        let width = infoType.width + 35
        vc.preferredContentSize = CGSize(width: width, height: 34)

        let ppc = vc.popoverPresentationController
        ppc?.permittedArrowDirections = .down
        ppc?.delegate = self
        ppc?.backgroundColor = ColorName.primaryOrange.color
        ppc?.sourceView = infoView
        ppc?.popoverBackgroundViewClass = CustomPopoverBackgroundView.self
        
        present(vc, animated: true, completion: nil)
    }
    
    private func showAnimateView() {
        UIView.animate(withDuration: 0.3, animations: {
            self.overlayView.alpha = 0.07
            self.infoView.alpha = 1
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    private func hideAnimateView() {
        UIView.animate(withDuration: 0.3, animations: {
            self.overlayView.alpha = 0
            self.infoView.alpha = 0
            self.view.layoutIfNeeded()
        }, completion: { (_) in
            self.view.removeFromSuperview()
            self.removeFromParent()
            self.closeInfoCallBack?()
        })
    }
}

extension InfoService: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }

    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        hideAnimateView()
        return true
    }
}

class CustomPopoverBackgroundView: UIPopoverBackgroundView {
    
    private var arrow  : Arrow = Arrow()
    private static let arrowImage = Asset.arrowPopUp.image
    private let arrowImageView = UIImageView(image: Asset.arrowPopUp.image)
    let backgroundImageView = UIImageView()
    
    override class func arrowBase() -> CGFloat {
        return arrowImage.size.width
    }
    
    override class func arrowHeight() -> CGFloat {
        return arrowImage.size.height
    }
    
    override class func contentViewInsets() -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    override var arrowDirection : UIPopoverArrowDirection
    {
        get{
            return arrow.direction.toPopoverArrowDirection()
        }
        set{
            if let direction = Direction.fromPopoverArrowDirection(direction: newValue) {
                arrow.direction = direction
            }
        }
    }
    
    override var arrowOffset: CGFloat
    {
        get{
            return arrow.offset
        }
        set{
            arrow.offset = arrow.offset
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundImageView.backgroundColor = ColorName.primaryOrange.color
        backgroundImageView.cornerRadius = 10
        addSubview(backgroundImageView)
        addSubview(arrowImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        var bgRect = bounds
        let cutWidth = arrowDirection == .left || arrowDirection == .right
        bgRect.size.width = bgRect.size.width - cutWidth.floatValue * CustomPopoverBackgroundView.arrowHeight() - 16
        bgRect.origin.x = 16
        
        let cutHeight = arrowDirection == .up || arrowDirection == .down
        bgRect.size.height = bgRect.size.height - cutHeight.floatValue * CustomPopoverBackgroundView.arrowHeight()

        if arrowDirection == .up {
            bgRect.origin.y += CustomPopoverBackgroundView.arrowHeight()
        } else if arrowDirection == .left {
            bgRect.origin.x += CustomPopoverBackgroundView.arrowHeight()
        }

        backgroundImageView.frame = bgRect
        
        var arrowRect = CGRect.zero
        let bgCapInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        switch arrowDirection {
            case UIPopoverArrowDirection.up:
                arrowImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
                arrowRect = arrowImageView.frame
                arrowRect.origin.x = bounds.size.width / 2 + arrowOffset - arrowRect.size.width / 2
                arrowRect.origin.y = 0
            case UIPopoverArrowDirection.down:
                arrowImageView.transform = CGAffineTransform(scaleX: 1, y: -1)
                arrowRect = arrowImageView.frame
                arrowRect.origin.x = bounds.size.width / 2 + arrowOffset - arrowRect.size.width / 2
                arrowRect.origin.y = bounds.size.height - arrowRect.size.height
            case UIPopoverArrowDirection.left:
                arrowImageView.transform = CGAffineTransform(rotationAngle: -.pi/2)
                arrowRect = arrowImageView.frame
                arrowRect.origin.x = 0
                arrowRect.origin.y = bounds.size.height / 2 + arrowOffset - arrowRect.size.height / 2
                arrowRect.origin.y = CGFloat(fminf(Float(bounds.size.height - arrowRect.size.height - bgCapInsets.bottom), Float(arrowRect.origin.y)))
                arrowRect.origin.y = CGFloat(fmaxf(Float(bgCapInsets.top), Float(arrowRect.origin.y)))
            case UIPopoverArrowDirection.right:
                arrowImageView.transform = CGAffineTransform(rotationAngle: .pi/2)
                    arrowRect = arrowImageView.frame
                    arrowRect.origin.x = bounds.size.width - arrowRect.size.width
                    arrowRect.origin.y = bounds.size.height / 2 + arrowOffset - arrowRect.size.height / 2
                arrowRect.origin.y = CGFloat(fminf(Float(bounds.size.height - arrowRect.size.height - bgCapInsets.bottom), Float(arrowRect.origin.y)))
                arrowRect.origin.y = CGFloat(fmaxf(Float(bgCapInsets.top), Float(arrowRect.origin.y)))
                default:
                    break
            }

            arrowImageView.frame = arrowRect
    }
    
    
}

enum Direction
{
    case UP
    case DOWN
    case LEFT
    case RIGHT
}

private struct Arrow
{
    var direction : Direction = .DOWN
    var offset    : CGFloat   = -50.0
}

extension Direction
{
    static func fromPopoverArrowDirection(direction:UIPopoverArrowDirection) -> Direction?
    {
        switch direction
        {
            case UIPopoverArrowDirection.up:
                return .UP
            case UIPopoverArrowDirection.down:
                return .DOWN
            case UIPopoverArrowDirection.left:
                return .LEFT
            case UIPopoverArrowDirection.right:
                return .RIGHT
            default:
                return nil
        }
    }

    func toPopoverArrowDirection() -> UIPopoverArrowDirection
    {
        switch self
        {
            case .UP:
                return UIPopoverArrowDirection.up
            case .DOWN:
                return UIPopoverArrowDirection.down
            case .LEFT:
                return UIPopoverArrowDirection.left
            case .RIGHT:
                return UIPopoverArrowDirection.right
        }
    }
}
