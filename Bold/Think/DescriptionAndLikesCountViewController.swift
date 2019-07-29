//
//  DescriptionAndLikesCountViewController.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/16/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

class DescriptionAndLikesCountViewController: UIViewController {
    
    @IBOutlet var likseCountView: OverTabbarView!
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var toolbar: UIToolbar!
    
    @IBAction func tapCloseButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    var percent : CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        likseCountView.configView(superView: view)
        likseCountView.delegate = self
    }
    
}

extension DescriptionAndLikesCountViewController: OverTabbarViewDelegate {
    func tapAddAction() {
        let addVC = AddActionPlanViewController.createController {
            print("tap AddActionPlan")
        }
        addVC.presentedBy(self)
    }
    
    func tapShare() {
        self.shareContent(item: nil)
    }
}

extension DescriptionAndLikesCountViewController: UIScrollViewDelegate {
    
    func calculatePosition(scrollView: UIScrollView) {
        
        if percent != 0 {
            scrollView.setContentOffset(CGPoint(x: scrollView.contentOffset.x, y: scrollView.contentSize.height - scrollView.frame.size.height), animated: true)
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        calculatePosition(scrollView: scrollView)
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {

        calculatePosition(scrollView: scrollView)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {

        calculatePosition(scrollView: scrollView)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        if scrollView.contentSize.height != 0 {
            let sizeTransform = scrollView.contentOffset.y - (scrollView.contentSize.height - scrollView.frame.size.height - 56)
            percent = (sizeTransform / 56)
            if 0 > percent {
                percent = 0
            }
            if percent > 1 {
                percent = 1
            }
            toolbar.alpha = 1 - percent
            likseCountView.moveConstraintView(percent: percent)
        }
    }
}
