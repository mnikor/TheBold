//
//  DescriptionAndLikesCountViewController.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/16/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit
import PDFKit

class DescriptionAndLikesCountViewController: UIViewController {
    
    @IBOutlet var likseCountView: OverTabbarView!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var pdfContainerView: UIView!
    @IBOutlet weak var pdfContainerHeightConstraint: NSLayoutConstraint!
    
    @IBAction func tapCloseButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    var percent : CGFloat = 0
    var content: ActivityContent?
    
    private var pdfView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        config()
        configurePDFView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configurePDFDocument()
    }
    
    private func config() {
        categoryLabel.text = content?.type.rawValue.capitalized
        titleLabel.text = content?.title
        likseCountView.configView(superView: view)
        likseCountView.delegate = self
        imageView.setImageAnimated(path: content?.imageURL ?? "",
                                   placeholder: Asset.serfer.image)
    }
    
    private func configurePDFView() {
        if #available(iOS 11.0, *) {
            pdfView = PDFView()
            guard let pdfView = pdfView as? PDFView else { return }
            pdfContainerView.addSubview(pdfView)
            pdfView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            pdfView.autoScales = true
            pdfView.delegate = self
        }
    }
    
    private func configurePDFDocument() {
        if #available(iOS 11.0, *) {
            guard let content = content,
                let documentURL = URL(string: content.documentURL ?? ""),
                let document = PDFDocument(url: documentURL),
                let pdfView = pdfView as? PDFView
                else { return }
            pdfView.document = document
            if let documentView = pdfView.documentView {
                pdfContainerHeightConstraint.constant = documentView.frame.size.height
                pdfContainerView.layoutIfNeeded()
            }
        }
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

extension DescriptionAndLikesCountViewController: PDFViewDelegate {
    
}
