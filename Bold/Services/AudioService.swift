//
//  AudioService.swift
//  Bold
//
//  Created by Alexander Kovalov on 6/21/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit
//import AVFoundation

enum AudioServiceInput {
    case play(audioName: String)
    case pause
    case resume
    case restart
}

enum AudioServiceOutput {
    case isPaying(Bool)
}

protocol AudioServiceProtocol {
    func input(_ inputCase: AudioServiceInput)
//    func output(_ outputCase: AudioServiceOutput)
}

class AudioService: NSObject, AudioServiceProtocol {
    
    static let shared = AudioService()
    
    let player = AudioPlayer()
    
    func input(_ inputCase: AudioServiceInput) {
        
        switch inputCase {
        case .play(let audioName):
            play(audioName: audioName)
        case .pause:
            player.pause()
        case .resume:
            player.resume()
        case .restart:
            player.restart()
        }
        
    }
    //delegate.stop()
    
    func play(audioName: String) {
       try? player.play(audioName: audioName)
    }
    
}
