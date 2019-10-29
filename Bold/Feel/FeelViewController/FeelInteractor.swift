//
//  FeelInteractor.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/22/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation

enum FeelInteractorInput {
    case prepareTracks(content: ActivityContent)
    case prepareDataSource(contentTypeArray: [ContentType], completion: (([ContentType: [ActivityContent]]) -> Void))
}

protocol FeelInteractorInputProtocol: InteractorProtocol {
    func input(_ inputCase: FeelInteractorInput)
}

class FeelInteractor: FeelInteractorInputProtocol {
    
    typealias Presenter = FeelPresenter
    
    weak var presenter: FeelPresenter!
    
    private var dataSource: [ContentType: [ActivityContent]] = [:]
    private var count = 0
    
    required init(presenter: Presenter) {
        self.presenter = presenter
    }
    
    func input(_ inputCase: FeelInteractorInput) {
        switch inputCase {
        case .prepareTracks(content: let content):
            prepareTracks(for: content)
        case .prepareDataSource(contentTypeArray: let contentTypes, completion: let completion):
            count = contentTypes.count
            prepareDataSource(contentTypeArray: contentTypes, completion: completion)
        }
    }
    
    private func prepareTracks(for content: ActivityContent) {
        let tracks = content.audiosURLs.compactMap { AudioPlayerTrackInfo(trackName: $0, artistName: $0, duration: formatTimeInterval(1254), path: .remote($0)) }
        AudioService.shared.tracks = tracks
    }
    
    private func prepareDataSource(contentTypeArray: [ContentType], completion: (([ContentType: [ActivityContent]]) -> Void)?) {
        var contentTypeArray = contentTypeArray
        guard let type = contentTypeArray.first else { return }
        NetworkService.shared.getContent(with: type) { [weak self] result in
            guard let self = self else { return }
            
            self.prepareDataSource(contentTypeArray: Array(contentTypeArray.dropFirst()), completion: completion)
            
            switch result {
            case .failure(let error):
                self.count -= 1
            case .success(let content):
                self.dataSource[type] = content
            }
            if self.dataSource.keys.count == self.count {
                completion?(self.dataSource)
            }
        }
    }
    
    private func formatTimeInterval(_ timeInterval: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [ .minute, .second ]
        formatter.zeroFormattingBehavior = [ .pad ]
        return formatter.string(from: timeInterval) ?? "0:00"
    }
    
}
