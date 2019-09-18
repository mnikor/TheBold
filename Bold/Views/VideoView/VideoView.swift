//
//  VideoView.swift
//  Bold
//
//  Created by Admin on 9/17/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

protocol VideoViewDelegate: class {
    func videoViewDidEndPlayingVideo()
    func videoViewStartPlaying()
}

class VideoView: UIView {
    weak var delegate: VideoViewDelegate?
    
    var duration: Double {
        return player?.currentItem?.asset.duration.seconds ?? 0
    }
    
    private var playerLayer: AVPlayerLayer?
    private var player: AVPlayer?
    
    func configure(url: URL) {
        player = AVPlayer(url: url)
        player?.automaticallyWaitsToMinimizeStalling = false
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.frame = bounds
        playerLayer?.videoGravity = .resizeAspectFill
        if let playerLayer = self.playerLayer {
            layer.addSublayer(playerLayer)
        }
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reachTheEndOfTheVideo(_:)),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                               object: self.player?.currentItem)
    }
    
    func play() {
        if player?.timeControlStatus != .playing {
            player?.play()
            delegate?.videoViewStartPlaying()
        }
    }
    
    func pause() {
        player?.pause()
    }
    
    func stop() {
        player?.pause()
        player?.seek(to: .zero)
    }
    
    @objc private func reachTheEndOfTheVideo(_ notification: Notification) {
        delegate?.videoViewDidEndPlayingVideo()
    }
    
}
