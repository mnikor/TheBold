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
    @IBOutlet weak var downloadButton: UIBarButtonItem!
    @IBOutlet weak var likeButton: UIBarButtonItem!
    @IBOutlet weak var bottomToolbarConstraint: NSLayoutConstraint!
    
    var buttonsToolbar = StateStatusButtonToolbar()
    
    private var isDocumentLoaded: Bool = false
    var isDownloadedContent = false
    
    var percent : CGFloat = 0
    var viewModel: DescriptionViewModel?
    
    private var pdfView: UIView?
    private var loader = LoaderView(frame: .zero)
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        modalPresentationStyle = .overCurrentContext
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
        configurePDFView()
        registerForNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !isDocumentLoaded {
            let centerY = UIScreen.main.bounds.height / 2
            let loaderHeight = UIScreen.main.bounds.width * 0.2
            let yOffSet = ((loaderHeight * 0.5) + 355) - centerY
            loader.start(in: view, yOffset: yOffSet < 0 ? 0 : yOffSet)
            view.bringSubviewToFront(loader)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !isDocumentLoaded {
            DispatchQueue.global().async { [weak self] in
                self?.configurePDFDocument()
            }
        }
    }
    
    private func config() {
        imageView.image = nil
        imageView.backgroundColor = ColorName.typographyBlack100.color
        configureDowloadButton()
        categoryLabel.text = viewModel?.category?.rawValue.capitalized
        
        if viewModel?.toolbarIsHidden == true {
            let bottomSafeArea: CGFloat
            guard let root = UIApplication.shared.keyWindow?.rootViewController else {
                return
            }
            
            if #available(iOS 11.0, *) {
                bottomSafeArea = root.view.safeAreaInsets.bottom
            } else {
                bottomSafeArea = root.bottomLayoutGuide.length
            }
            
            bottomToolbarConstraint.constant = -toolbar.bounds.height - bottomSafeArea
            view.layoutIfNeeded()
        }
    
        toolbar.isHidden = viewModel?.toolbarIsHidden ?? false
        titleLabel.text = viewModel?.title
        likseCountView.configView(superView: view)
        likseCountView.likesCountButtons.setTitle(String(viewModel?.likesCount ?? 0))
        likseCountView.delegate = self
        switch viewModel?.image {
        case .image(let image):
            if let image = image {
                imageView.image = image
            } else {
                imageView.image = nil//Asset.serfer.image
            }
        case .path(let path):
            imageView.setImageAnimated(path: path ?? "")
                                       //placeholder: Asset.serfer.image)
        case nil:
            imageView.image = nil//Asset.serfer.image
        }
        playerButton.cornerRadius()
        playerButton.positionImageBeforeText(padding: 8)
        playerButton.shadow()
        playerButton.isHidden = (viewModel?.audioTracks ?? []).isEmpty
        likseCountView.isHidden = !(viewModel?.isLikesEnabled ?? false)
    }
    
    private func configureDowloadButton() {
        buttonsToolbar.dowload = isDownloadedContent
//        downloadButton.image = buttonsToolbar.dowload == false ? Asset.playerDownloadIcon.image : Asset.playerDownloadedIcon.image
        downloadButton.tintColor = buttonsToolbar.dowload == false ? .gray : ColorName.primaryBlue.color
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
//            pdfContainerView.bringSubviewToFront(playerButton)
            pdfView.autoScales = true
            pdfView.backgroundColor = .clear
            if #available(iOS 12.0, *) {
                pdfView.pageShadowsEnabled = false
            } else {
                pdfView.displaysPageBreaks = false
            }
            
        }
    }
    
    private func registerForNotifications() {
        if #available(iOS 11.0, *) {
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(documentChanged(_:)),
                                                   name: Notification.Name.PDFViewDocumentChanged,
                                                   object: nil)
        }
    }
    
    private func configurePDFDocument() {
        if #available(iOS 11.0, *) {
            guard let documentURL = viewModel?.documentURL,
                let document = PDFDocument(url: documentURL),
                let pdfView = pdfView as? PDFView
                else { return }
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                pdfView.document = document
                if let documentView = pdfView.documentView {
                    self.pdfContainerHeightConstraint.constant = documentView.frame.size.height + 25
                    self.pdfContainerView.layoutIfNeeded()
                    pdfView.backgroundColor = .white
                }
            }
        }
    }
    
    @objc private func documentChanged(_ notification: Notification) {
        loader.stop()
        isDocumentLoaded = true
    }
    
    @IBAction func tapCloseButton(_ sender: UIButton) {
            self.dismiss(animated: true, completion: nil)
        }
        
        @IBAction func didTapAtPlayerButton(_ sender: UIButton) {
            PlayerViewController.createController(content: viewModel?.content)
        }
        
        @IBAction func didTapAtDownloadButton(_ sender: UIBarButtonItem) {
            if !isDownloadedContent && !buttonsToolbar.dowload {
                buttonsToolbar.dowload = !buttonsToolbar.dowload
    //            downloadButton.image = buttonsToolbar.dowload == false ? Asset.playerDownloadIcon.image : Asset.playerDownloadedIcon.image
                downloadButton.tintColor = buttonsToolbar.dowload == false ? .gray : ColorName.primaryBlue.color
    //            audioPlayerDelegate?.saveContent()
            }
        }
        
        @IBAction func didTapAtAddActionPlan(_ sender: UIBarButtonItem) {
            AlertViewService.shared.input(.addAction(content: viewModel?.content, tapAddPlan: {
                print("didTapAtAddActionPlan")
            }))
        }
        
        @IBAction func didTapAtLikeButton(_ sender: UIBarButtonItem) {
            buttonsToolbar.like = !buttonsToolbar.like
            likeButton.image = buttonsToolbar.like == false ? Asset.playerLikeIcon.image : Asset.playerLikedIcon.image
            likeButton.tintColor = buttonsToolbar.like == false ? .gray : ColorName.primaryRed.color
    //        audioPlayerDelegate?.likeContent(buttonsToolbar.like)
        }
    
}

extension DescriptionAndLikesCountViewController: OverTabbarViewDelegate {
    func tapAddAction() {
        AlertViewService.shared.input(.addAction(content: viewModel?.content, tapAddPlan: {
            print("tapAddAction")
        }))
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
//            toolbar.alpha = 1 - percent
//            likseCountView.moveConstraintView(percent: percent)
        }
    }
    
}
