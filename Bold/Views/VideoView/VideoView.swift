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
    
    private var playerLayer: AVPlayerLayer!
    private var player: AVPlayer?
    private var willLoopVideo: Bool!
    
    func configure(url: URL, willLoopVideo: Bool = false) {
        player = AVPlayer(url: url)
        player?.isMuted = true
        player?.actionAtItemEnd = .none
        self.willLoopVideo = willLoopVideo
        player?.automaticallyWaitsToMinimizeStalling = false
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = bounds
        playerLayer.videoGravity = .resizeAspectFill
        playerLayer.zPosition = -1
        playerLayer.needsDisplayOnBoundsChange = true
        if let playerLayer = self.playerLayer {
            layer.addSublayer(playerLayer)
            //layer.insertSublayer(playerLayer, at: 0)
        }
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(reachTheEndOfTheVideo(_:)),
//                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
//                                               object: self.player?.currentItem)
        
        NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: self.player?.currentItem,
            queue: .main) { [weak self] _ in
                if let willLoopVideo = self?.willLoopVideo, willLoopVideo {
                    self?.restart()
                    return
                }
            self?.delegate?.videoViewDidEndPlayingVideo()
        }
        
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
    
    func restart() {
        player?.seek(to: CMTime.zero)
        play()
    }
    
//    @objc private func reachTheEndOfTheVideo(_ notification: Notification) {
//        
//        if willLoopVideo {
//            DispatchQueue.main.async {[weak self] in
//                self?.restart()
//            }
//            return
//        }
//        delegate?.videoViewDidEndPlayingVideo()
//    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player?.currentItem)
    }
    
}
