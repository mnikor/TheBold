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
    @IBOutlet weak var playerButton: UIButton!
    
    @IBAction func tapCloseButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapAtPlayerButton(_ sender: UIButton) {
        AudioService.shared.tracks = viewModel?.audioTracks ?? []
        AudioService.shared.image = viewModel?.image
        AudioService.shared.showPlayerFullScreen()
    }
    
    var percent : CGFloat = 0
    var viewModel: DescriptionViewModel?
    
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
        categoryLabel.text = viewModel?.category?.rawValue.capitalized
        titleLabel.text = viewModel?.title
        likseCountView.configView(superView: view)
        likseCountView.likesCountButtons.setTitle(String(viewModel?.likesCount ?? 0))
        likseCountView.delegate = self
        switch viewModel?.image {
        case .image(let image):
            if let image = image {
                imageView.image = image
            } else {
                imageView.image = Asset.serfer.image
            }
        case .path(let path):
            imageView.setImageAnimated(path: path ?? "",
                                       placeholder: Asset.serfer.image)
        case nil:
            imageView.image = Asset.serfer.image
        }
        playerButton.cornerRadius()
        playerButton.positionImageBeforeText(padding: 8)
        playerButton.shadow()
        playerButton.isHidden = (viewModel?.audioTracks ?? []).isEmpty
        likseCountView.isHidden = viewModel?.isLikesEnabled == false
    }
    
    private func configurePDFView() {
        if #available(iOS 11.0, *) {
            pdfView = PDFView()
            guard let pdfView = pdfView as? PDFView else { return }
            pdfContainerView.addSubview(pdfView)
            pdfView.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(25)
                make.leading.trailing.bottom.equalToSuperview()
            }
            pdfContainerView.bringSubviewToFront(playerButton)
            pdfView.autoScales = true
            pdfView.delegate = self
            if #available(iOS 12.0, *) {
                pdfView.pageShadowsEnabled = false
            } else {
                pdfView.displaysPageBreaks = false
            }
        }
    }
    
    private func configurePDFDocument() {
        if #available(iOS 11.0, *) {
            guard let documentURL = viewModel?.documentURL,
                let document = PDFDocument(url: documentURL),
                let pdfView = pdfView as? PDFView
                else { return }
            pdfView.document = document
            if let documentView = pdfView.documentView {
                pdfContainerHeightConstraint.constant = documentView.frame.size.height + 25
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
        guard viewModel?.isLikesEnabled == true else { return }
        
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
