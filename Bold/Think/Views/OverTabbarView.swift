//
//  OverTabbarView.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/15/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

protocol OverTabbarViewDelegate: class {
    func tapAddAction()
    func tapShare()
}

class OverTabbarView: UIView {

    @IBOutlet weak var likesCountButtons: UIButton!
    @IBOutlet weak var addActionButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    
    weak var delegate: OverTabbarViewDelegate?
    
    var viewBottomAnchor : NSLayoutConstraint!
    var superView: UIView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        startConfig()
    }
    
    func startConfig() {
        likesCountButtons.cornerRadius()
        addActionButton.cornerRadius()
        shareButton.cornerRadius()
        
        //hex color F1F1F4
        let colorBorder = UIColor(red: 241/255, green: 241/255, blue: 244/255, alpha: 1.0)
        likesCountButtons.borderWidth(color: colorBorder)
        addActionButton.borderWidth(color: colorBorder)
        shareButton.borderWidth(color: colorBorder)
        
        likesCountButtons.positionImageBeforeText(padding: 6)
        likesCountButtons.isUserInteractionEnabled = false
    }
    
    @IBAction func tapAddActionButton(_ sender: UIButton) {
        delegate?.tapAddAction()
    }
    
    @IBAction func tapShareButton(_ sender: UIButton) {
        delegate?.tapShare()
    }
    
    func moveConstraintView(percent: CGFloat) {
        viewBottomAnchor.constant = -percent * 100
        self.superView.layoutIfNeeded()
    }
    
    func configView(superView: UIView) {
        
        self.superView = superView
        
        let frame = CGRect(x: 0, y: superView.bounds.size.height, width: superView.bounds.size.width, height: superView.bounds.size.height)
        
        self.frame = frame
        superView.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        viewBottomAnchor = self.topAnchor.constraint(equalTo: superView.bottomAnchor, constant: 0)
        
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: 100),
            self.leftAnchor.constraint(equalTo: superView.leftAnchor),
            self.rightAnchor.constraint(equalTo: superView.rightAnchor),
            viewBottomAnchor])
    }
    
//    func showViewAnimate() {
//        UIView.animate(withDuration: 0.3) {
//            self.topBottomAnchor.isActive = false
//            self.topTopAnchor.isActive = true
//            self.superView.layoutIfNeeded()
//        }
//    }
//
//    func hideViewAnimate() {
//        UIView.animate(withDuration: 0.3, animations: {
//            self.topTopAnchor.isActive = false
//            self.topBottomAnchor.isActive = true
//            self.superView.layoutIfNeeded()
//        }, completion: { [unowned self] (_) in
//            self.removeFromSuperview()
//        })
//    }
}
