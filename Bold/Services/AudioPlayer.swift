//
//  AudioPlayer.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/5/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation
import AVFoundation
import AVKit
import MediaPlayer

enum FilePath {
    case local(String)
    case remote(String)
}

struct AudioPlayerTrackInfo {
    var trackName: String
    var artistName: String
    var duration: String
    var path: FilePath
}

protocol AudioPlayerDelegate: class {
    func audioPlayerDidChangeStatus(to status: AVPlayerItem.Status?)
    func audioPlayerDidChangeTimeControlStatus(to status: AVPlayer.TimeControlStatus)
}

public class AudioPlayer: NSObject {
    weak var delegate: AudioPlayerDelegate?
    
    var duration: CMTime? {
        return player.currentItem?.asset.duration
    }
    
    var currentTime: CMTime {
        return player.currentTime()
    }
    
    var playerItem: AVPlayerItem?
    var player = AVPlayer()
    var audioSession = AVAudioSession.sharedInstance()
    var observer: NSKeyValueObservation?
    
    private var currentTrackInfo: AudioPlayerTrackInfo?
    
    public override init() {
        super.init()
        setupRemoteControls()
    }
    
    private func setupRemoteControls() {
        let commandCenter = MPRemoteCommandCenter.shared()
        
        commandCenter.playCommand.addTarget { [unowned self] event in
            if self.player.rate == 0 {
                self.resume()
                return .success
            }
            return .commandFailed
        }
        
        commandCenter.pauseCommand.addTarget { [unowned self] event in
            if self.player.rate != 0 {
                self.pause()
                return .success
            }
            return .commandFailed
        }
        
        commandCenter.previousTrackCommand.addTarget { [unowned self] event in
            AudioService.shared.input(.playPrevious)
            return .success
        }
        
        commandCenter.nextTrackCommand.addTarget { [unowned self] event in
            AudioService.shared.input(.playNext)
            return .success
        }
    }
    
    private func setupNowPlaying() {
        var nowPlayingInfo = [String : Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = currentTrackInfo?.trackName ?? ""
        nowPlayingInfo[MPMediaItemPropertyArtist] = currentTrackInfo?.artistName ?? ""
        
        
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = currentTime.seconds
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = (duration?.seconds ?? 0)
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = player.rate
        
        // Set the metadata
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
    func setupTracks() {
        
    }
    
    func observePlayer() {
        
        observer = player.observe(\.timeControlStatus, options: [.new]) {
            [weak self] (player, _) in
            self?.delegate?.audioPlayerDidChangeTimeControlStatus(to: player.timeControlStatus)
        }
    }
    
    func play(with trackInfo: AudioPlayerTrackInfo) {
        currentTrackInfo = trackInfo
        let path: URL?
        switch trackInfo.path {
        case .local(let localPath):
            path = URL(fileURLWithPath: localPath)
        case .remote(let remotePath):
            path = URL(string: remotePath)
        }
        
        guard let url = path else { return }
        do {
            try audioSession.setCategory(.playback)
            let asset = AVAsset(url: url)
            playerItem = AVPlayerItem(asset: asset)
            player = AVPlayer(playerItem: playerItem)
            observePlayer()
            player.automaticallyWaitsToMinimizeStalling = false
            player.play()
            setupNowPlaying()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func stop() {
        player.pause()
    }
    
    func pause() {
        player.rate = 0
    }
    
    func resume() {
        player.rate = 1
    }
    
    func restart() {
    }
    
    func seek(to time: CMTime) {
        player.seek(to: time) { [unowned self] _ in
            self.setupNowPlaying()
        }
    }
    
    func isPlaying() -> Bool {
        return player.rate > 0
    }
    
}


public enum AudioBackgroundError: LocalizedError {
    case audioNotFound(name: String)
    case audioNotPlay(name: String)
    case audioSessionError(error: Error)
    
    /// Description of the error.
    public var errorDescription: String? {
        switch self {
        case .audioNotFound(let audioName):
            return "Could not find \(audioName)."
        case .audioNotPlay(let audioName):
            return "Could not play \(audioName)."
        case .audioSessionError(let error):
            return "Audio session error = \(error)"
        }
        
    }
}
