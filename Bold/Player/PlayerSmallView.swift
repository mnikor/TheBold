//
//  PlayerSmallView.swift
//  Bold
//
//  Created by Alexander Kovalov on 6/24/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

class PlayerSmallView: UIView {
    private var timer: Timer?
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var actionImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    
    @IBOutlet weak var playButton: UIButton!
    
    var currentContent: ActivityContent?
    
    @IBAction func tapPlayButton(_ sender: UIButton) {
        if AudioService.shared.isPlaying() {
            AudioService.shared.input(.pause)
        } else {
            AudioService.shared.input(.resume)
        }
        changeImageButton()
    }
    
    @IBAction func tapCloseButton(_ sender: UIButton) {
        AudioService.shared.input(.stop)
        animateDisappearing()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerIsPlaying()
    }
    
    private func updateProgress() {
        let currentTime = AudioService.shared.getCurrentTime().seconds
        let fullTime = AudioService.shared.getDuration()?.seconds ?? currentTime
        progressView.progress = Float(currentTime / fullTime)
    }
    
    private func changeImageButton() {
        playButton.setImage(AudioService.shared.isPlaying() ? Asset.playerSmallPause.image : Asset.playerSmallPlay.image, for: .normal)
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("PlayerSmallView", owner: self)
        contentView.fixInView(self)
        
        AudioService.shared.input(.smallView(activityType: {[weak self] (typeActivity) in
            switch typeActivity {
            case .appearing:
                self?.showSmallPlayer()
            case .disappearing:
                self?.animateDisappearing(completion: {[weak self] in
                    self?.showPlayerFullScreen(isDownloadedContent: AudioService.shared.isDownloadedContent)
                })
            case .disappearingCompletion(let completion):
                self?.animateDisappearing(completion: completion)
            }
        }))
    }
    
    @IBAction func didTapAtView(_ sender: UITapGestureRecognizer) {
        animateDisappearing {
            self.showPlayerFullScreen(isDownloadedContent: AudioService.shared.isDownloadedContent)
//            AudioService.shared.showPlayerFullScreen(isDownloadedContent: AudioService.shared.isDownloadedContent)
        }
    }
    
    private func showSmallPlayer() {
        changeImageButton()
        AudioService.shared.delegate = self
        UIApplication.shared.keyWindow?.addSubview(self)
        if let _ = UIApplication.shared.keyWindow {
            self.snp.makeConstraints { make in
                make.bottom.leading.trailing.equalToSuperview()
            }
        }
        setNeedsLayout()
        layoutIfNeeded()
        animateAppearing()
    }
    
    private func animateAppearing() {
        self.frame.origin.y = UIScreen.main.bounds.maxY
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.frame.origin.y -= 60
        })
    }
    
    private func animateDisappearing(completion: VoidCallback? = nil) {
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.frame.origin.y = UIScreen.main.bounds.maxY
        }) { [weak self] _ in
            self?.removeFromSuperview()
            AudioService.shared.input(.destroySmallPlayer)
            completion?()
        }
    }
    
    private func showPlayerFullScreen(isDownloadedContent: Bool) {
//            smallPlayer.animateDisappearing() { [unowned self] in
        
        AudioService.shared.input(.stop)
        guard let content = currentContent else { return }
        PlayerViewController.createController(content: content)
        
//                let playerVC = PlayerViewController.createController()
//                self.delegate = playerVC
//                self.isDownloadedContent = isDownloadedContent
//    //            playerVC.delegate = self.playerDelegate
//                playerVC.isDownloadedContent = isDownloadedContent
//                UIApplication.topViewController?.present(playerVC, animated: true)
            }
//        }
    
}

extension PlayerSmallView: AudioServiceDelegate {
    
    func playerStoped(with totalDuration: TimeInterval) {
        currentContent?.playerStoped(with: totalDuration)
    }
    
    func playerIsPlaying() {
        timer?.invalidate()
        titleLabel.text = AudioService.shared.getCurrentTrackName()
        subtitleLabel.text = AudioService.shared.getCurrentArtistName()
        if let imagePath = AudioService.shared.getCurrentImagePath() {
            actionImageView.setImageAnimated(path: imagePath, placeholder: Asset.playerSmallImage.image)
        }
        
        updateProgress()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.updateProgress()
        }
    }
    
    func playerFailed() {
        // TODO: player failed message
    }
    
    func playerPaused() {
        timer?.invalidate()
    }
    
}
