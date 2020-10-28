//
//  CitationViewController.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/9/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

class CitationViewController: UIViewController, AlertDisplayable {

    @IBOutlet weak var authorImageView: CustomImageView!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var citationTextView: UITextView!
    @IBOutlet weak var contentAnimationView: UIView!
    @IBOutlet weak var shareButton: UIButton!
    
    @IBAction func tapShareButton(_ sender: UIButton) {
        configureShareActivity()
    }
    
    var animationContent: AnimationContentView?
    var alertController: BlurAlertController?
    
    var quote: ActivityContent?
    var color: ColorGoalType = .none
    private var currentColor : UIColor?
    private var imagePath: String?
    private var isImageAnim: Bool = false
    
    lazy var animationImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            authorImageView.bottomAnchor.constraint(equalTo: imageView.topAnchor, constant: 20),
            shareButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            view.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 16),
            ])
        imageView.isHidden = true
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        citationTextView.removeInsets()
        navigationController?.setNavigationBarHidden(true, animated: true)
        configure()
    }
    
    func configure() {
        
        authorImageView.cornerRadius = authorImageView.bounds.size.height / 2
        authorImageView.image = nil
        authorImageView.backgroundColor = .clear
        
        if let authorPhotoURL = quote?.authorPhotoURL {
            authorImageView.downloadImageAnimated(path: authorPhotoURL)
        }else {
            authorImageView.image = nil
        }
        authorNameLabel.text = quote?.authorName
        
        citationTextView.text = quote?.body
        citationTextView.isHidden = false
        
        if let colorHex = quote?.color{
            currentColor = UIColor.hexStringToUIColor(hex: colorHex)
            view.backgroundColor = UIColor.hexStringToUIColor(hex: colorHex)
        }else {
            view.backgroundColor = color.colorGoal()
        }
        
        if let animationName = quote?.animationKey {
            
            let fileName = DataSource.shared.searchFile(forKey: animationName, type: .anim_json)?.path
            let fileImage = DataSource.shared.searchFile(forKey: animationName, type: .anim_image)?.path
            
            if fileName == nil && fileImage != nil {
                if let filePath = readFiles(name: fileImage!).first {
                    isImageAnim = true
                    animationImageView.isHidden = false
                    animationImageView.image = UIImage(contentsOfFile: filePath.path)
                }
            }
            
//            imagePath =  readFiles(name: animationName + "_image").first?.path
//            let fileName = DataSource.shared.searchFile(forKey: animationName, type: .anim_image)?.path
            imagePath = readFiles(name: fileImage ?? "1234567890").first?.path
            citationTextView.isHidden = true
            DispatchQueue.main.async {
                self.animationContent = AnimationContentView.setupAnimation(view: self.contentAnimationView, name: animationName, delay: 3)
                self.animationContent?.play()
            }
        }
    }
    
    private func readFiles(name: String) -> [URL] {
        let files = FileLoader.findFile(name: name)
        return files
    }
    
    func updateTextFont() {
        if (citationTextView.text.isEmpty || citationTextView.bounds.size.equalTo(CGSize.zero)) {
            return;
        }

        let textViewSize = citationTextView.frame.size;
        let fixedWidth = textViewSize.width;
        let expectSize = citationTextView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat(MAXFLOAT)));
        let minimumFontSize : CGFloat = 20;

        var expectFont = citationTextView.font;
        if (expectSize.height > textViewSize.height) {
            while (citationTextView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat(MAXFLOAT))).height > textViewSize.height) && minimumFontSize < citationTextView.font!.pointSize {
                expectFont = citationTextView.font!.withSize(citationTextView.font!.pointSize - 1)
                citationTextView.font = expectFont
            }
        }
//        else {
//            while (citationTextView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat(MAXFLOAT))).height < textViewSize.height) {
//                expectFont = citationTextView.font;
//                citationTextView.font = citationTextView.font!.withSize(citationTextView.font!.pointSize + 1)
//            }
//            citationTextView.font = expectFont;
//        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateTextFont()
    }
    
    func configureShareActivity() {
        let shareView = RateAndShareView.loadFromNib()
        shareView.delegate = self
        
        shareView.configureCitation(authorImage: authorImageView.image,
                                    authorName: quote?.authorName,
                                    citation: quote?.body,
                                    imagePath: imagePath,
                                    color: currentColor != nil ? currentColor! : color.colorGoal(),
                                    isImageAnim: isImageAnim)
        
        alertController = showAlert(with: shareView)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animationContent?.play()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        animationContent?.stop()
    }
    
    deinit {
        print("DEINIT - CitationViewController")
    }
    
}

extension CitationViewController: RateAndShareViewDelegate {
    func rateUs() {
        
    }
    
    func share(with image: UIImage, actionType: String) {
        let title = GlobalConstants.appURL
        let image = image
        let appLink = URL(string: GlobalConstants.appURL)!
        
        let items: [Any] = [title, image, appLink]
        
        alertController?.shareContent(with: items)
    }
}
