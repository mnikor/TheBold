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
    
    @IBAction func tapPlayButton(_ sender: UIButton) {
        if AudioService.shared.isPlaying() {
            AudioService.shared.input(.pause)
        } else {
            AudioService.shared.input(.resume)
        }
    }
    
    @IBAction func tapCloseButton(_ sender: UIButton) {
        AudioService.shared.input(.stop)
        animateDisappering()
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
    
    func commonInit() {
        Bundle.main.loadNibNamed("PlayerSmallView", owner: self)
        contentView.fixInView(self)
    }
    
    @IBAction func didTapAtView(_ sender: UITapGestureRecognizer) {
        animateDisappering {
            AudioService.shared.showPlayerFullScreen()
        }
    }
    
    func animateAppearing() {
        self.frame.origin.y = UIScreen.main.bounds.maxY
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.frame.origin.y -= 60
        })
    }
    
    private func animateDisappering(completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.frame.origin.y = UIScreen.main.bounds.maxY
        }) { [weak self] _ in
            self?.removeFromSuperview()
            completion?()
        }
    }
    
}

extension PlayerSmallView: AudioServiceDelegate {
    func playerIsPlaying() {
        timer?.invalidate()
        titleLabel.text = AudioService.shared.getCurrentTrackName()
        subtitleLabel.text = AudioService.shared.getCurrentArtistName()
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
