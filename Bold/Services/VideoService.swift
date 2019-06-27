//
//  VideoService.swift
//  Bold
//
//  Created by Alexander Kovalov on 6/21/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit
import SwiftVideoBackground

enum VideoServiceInput {
    case play(videoName: String)
    case pause
    case resume
    case restart
}

protocol VideoServiceProtocol {
    var view : UIView? { get set }
    func input(_ inputCase: VideoServiceInput)
}

class VideoService: NSObject, VideoServiceProtocol {

    weak var view: UIView?
    let player = VideoBackground()
    
    private func play(videoName: String) {
        
        guard let view = view else {
            return
        }

        try? player.play(
            view: view,
            videoName: videoName.fileName(),
            videoType: videoName.fileExtension(),
            isMuted: true,
            darkness: 0,
            willLoopVideo: true,
            setAudioSessionAmbient: false)
    }

    func input(_ inputCase: VideoServiceInput) {
        switch inputCase {
        case .play(let videoName):
            play(videoName: videoName)
        case .pause:
            player.pause()
        case .resume:
            player.resume()
        case .restart:
            player.restart()
        }
    }
    
}
