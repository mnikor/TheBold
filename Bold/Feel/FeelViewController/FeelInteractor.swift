//
//  FeelInteractor.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/22/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation

enum FeelInteractorInput {
    case prepareTracks
}

protocol FeelInteractorInputProtocol: InteractorProtocol {
    func input(_ inputCase: FeelInteractorInput)
}

class FeelInteractor: FeelInteractorInputProtocol {
    
    typealias Presenter = FeelPresenter
    
    weak var presenter: FeelPresenter!
    
    required init(presenter: Presenter) {
        self.presenter = presenter
    }
    
    func input(_ inputCase: FeelInteractorInput) {
        switch inputCase {
        case .prepareTracks:
            prepareTracks()
        }
    }
    
    private func prepareTracks() {
        var tracks = [AudioPlayerTrackInfo]()
        for index in 1 ... 5 {
            tracks.append(AudioPlayerTrackInfo(trackName: "Track\(index)", artistName: "Artist\(index)", duration: formatTimeInterval(1254) , path: .remote("https://www.soundhelix.com/examples/mp3/SoundHelix-Song-\(index).mp3")))
        }
        AudioService.shared.tracks = tracks
    }
    
    private func formatTimeInterval(_ timeInterval: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [ .minute, .second ]
        formatter.zeroFormattingBehavior = [ .pad ]
        return formatter.string(from: timeInterval) ?? "0:00"
    }
    
}
