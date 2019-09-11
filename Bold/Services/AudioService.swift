//
//  AudioService.swift
//  Bold
//
//  Created by Alexander Kovalov on 6/21/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer
//import AVFoundation

enum AudioServiceInput {
    case play(trackIndex: Int?)
    case playNext
    case playPrevious
    case stop
    case pause
    case resume
    case restart
    case seek(to: CMTime)
}

enum AudioServiceOutput {
    case isPaying(Bool)
}

protocol AudioServiceProtocol {
    func input(_ inputCase: AudioServiceInput)
//    func output(_ outputCase: AudioServiceOutput)
}

protocol AudioServiceDelegate: class {
    func playerIsPlaying()
    func playerFailed()
    func playerPaused()
}

class AudioService: NSObject, AudioServiceProtocol {
    
    static let shared = AudioService()
    
    let smallPlayer = PlayerSmallView()
    var tracks: [AudioPlayerTrackInfo] = []
    
    weak var delegate: AudioServiceDelegate?
    let player = AudioPlayer()
    
    private var currentTrackIndex: Int = 0
    
    override private init() {
        super.init()
        player.delegate = self
    }
    
    func addSubscriber(_ subscriber: AudioServiceDelegate) {
        
    }
    
    func input(_ inputCase: AudioServiceInput) {
        switch inputCase {
        case .play(let index):
            player.play(with: tracks[index ?? currentTrackIndex])
            currentTrackIndex = index ?? currentTrackIndex
        case .playPrevious:
            currentTrackIndex = currentTrackIndex - 1 >= 0
                ? currentTrackIndex - 1
                : currentTrackIndex
            player.play(with: tracks[currentTrackIndex])
        case .playNext:
            currentTrackIndex = currentTrackIndex + 1 >= tracks.count
                ? currentTrackIndex
                : currentTrackIndex + 1
            player.play(with: tracks[currentTrackIndex])
        case .stop:
            player.stop()
        case .pause:
            player.pause()
        case .resume:
            player.resume()
        case .restart:
            player.restart()
        case .seek(to: let time):
            player.seek(to: time)
        }
        
    }
    
    func isPlaying() -> Bool {
        return player.isPlaying()
    }
    
    func getDuration() -> CMTime? {
        return player.duration
    }
    
    func getCurrentTime() -> CMTime {
        return player.currentTime
    }
    
    func showSmallPlayer() {
        delegate = smallPlayer
        UIApplication.shared.keyWindow?.addSubview(smallPlayer)
        if let window = UIApplication.shared.keyWindow {
            smallPlayer.snp.makeConstraints { make in
                make.bottom.leading.trailing.equalToSuperview()
            }
        }
        smallPlayer.setNeedsLayout()
        smallPlayer.layoutIfNeeded()
        smallPlayer.animateAppearing()
    }
    
    func showPlayerFullScreen() {
        let playerVC = PlayerViewController.createController()
        delegate = playerVC
        UIApplication.shared.keyWindow?.rootViewController?.present(playerVC, animated: true, completion: nil)
    }
    
}

extension AudioService: AudioPlayerDelegate {
    func audioPlayerDidChangeTimeControlStatus(to status: AVPlayer.TimeControlStatus) {
        switch status {
        case .paused:
            delegate?.playerPaused()
        case .playing:
            delegate?.playerIsPlaying()
        case .waitingToPlayAtSpecifiedRate:
            break
        }
    }
    
    func audioPlayerDidChangeStatus(to status: AVPlayerItem.Status?) {
        switch status {
        case nil, .unknown?:
            break
        case .readyToPlay?:
            delegate?.playerIsPlaying()
        case .failed?:
            delegate?.playerFailed()
        }
    }
    
}
