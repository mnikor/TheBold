//
//  AudioPlayer.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/5/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation
import AVFoundation

public class AudioPlayer {
    
    var player = AVAudioPlayer()
    var audioSession = AVAudioSession.sharedInstance()
    
    func play(audioName: String) throws {
        
        guard let path = Bundle.main.path(forResource: audioName.fileName(), ofType: audioName.fileExtension()) else {
            throw AudioBackgroundError.audioNotFound(name: audioName)
        }
        
        let url = URL(fileURLWithPath: path)
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
        } catch {
            throw AudioBackgroundError.audioNotPlay(name: audioName)
        }
        
        player.prepareToPlay()
        
        do {
            try audioSession.setCategory(.playback)
        } catch {
            throw AudioBackgroundError.audioSessionError(error: error)
        }
        
        player.play()
        
    }
    
    func pause() {
        player.pause()
    }
    
    func resume() {
        player.play()
    }
    
    func restart() {
        if player.isPlaying {
            player.pause()
        }
        player.currentTime = 0
        player.play()
    }
    
    func isPlaying() -> Bool {
        return player.isPlaying
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
