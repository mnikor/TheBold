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
    var image: Image?
    
    weak var delegate: AudioServiceDelegate?
    let player = AudioPlayer()
    
    private var currentTrackIndex: Int = 0
    
    override private init() {
        super.init()
        setupRemoteControls()
        player.delegate = self
    }
    
    private func setupRemoteControls() {
        let commandCenter = MPRemoteCommandCenter.shared()
        
        commandCenter.playCommand.addTarget { [unowned self] event in
            if self.player.rate == 0 {
                self.player.resume()
                return .success
            }
            return .commandFailed
        }
        
        commandCenter.pauseCommand.addTarget { [unowned self] event in
            if self.player.rate != 0 {
                self.player.pause()
                return .success
            }
            return .commandFailed
        }
        
        commandCenter.previousTrackCommand.addTarget { [unowned self] event in
            self.playPrevious()
            return .success
        }
        
        commandCenter.nextTrackCommand.addTarget { [unowned self] event in
            self.playNext()
            return .success
        }
    }
    
    private func setupNowPlaying() {
        var nowPlayingInfo = [String : Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = tracks[currentTrackIndex].trackName
        nowPlayingInfo[MPMediaItemPropertyArtist] = tracks[currentTrackIndex].artistName
        
        
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = player.currentTime.seconds
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = (player.duration?.seconds ?? 0)
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = player.rate
        
        // Set the metadata
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
    private func playPrevious() {
        currentTrackIndex = currentTrackIndex - 1 >= 0
            ? currentTrackIndex - 1
            : currentTrackIndex
        player.play(with: tracks[currentTrackIndex])
    }
    
    private func playNext() {
        currentTrackIndex = currentTrackIndex + 1 >= tracks.count
            ? currentTrackIndex
            : currentTrackIndex + 1
        player.play(with: tracks[currentTrackIndex])
    }
    
    func addSubscriber(_ subscriber: AudioServiceDelegate) {
        
    }
    
    func input(_ inputCase: AudioServiceInput) {
        guard tracks.count > 0 else { return }
        switch inputCase {
        case .play(let index):
            currentTrackIndex = index ?? currentTrackIndex
            player.play(with: tracks[currentTrackIndex])
        case .playPrevious:
            playPrevious()
        case .playNext:
            playNext()
        case .stop:
            player.stop()
        case .pause:
            player.pause()
        case .resume:
            player.resume()
        case .restart:
            player.restart()
        case .seek(to: let time):
            player.seek(to: time) { [unowned self] in
                self.setupNowPlaying()
            }
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
    
    func getCurrentTrackName() -> String {
        return tracks[currentTrackIndex].trackName
    }
    
    func getCurrentArtistName() -> String {
        return tracks[currentTrackIndex].artistName
    }
    
    func showSmallPlayer() {
        delegate = smallPlayer
        UIApplication.shared.keyWindow?.addSubview(smallPlayer)
        if let _ = UIApplication.shared.keyWindow {
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
        UIApplication.topViewController?.present(playerVC, animated: true)
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
