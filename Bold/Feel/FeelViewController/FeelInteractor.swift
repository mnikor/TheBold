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
//    case downloadContent(ActivityContent)
}

protocol FeelInteractorInputProtocol: InteractorProtocol {
    func input(_ inputCase: FeelInteractorInput)
}

class FeelInteractor: FeelInteractorInputProtocol {
    
    typealias Presenter = FeelPresenter
    
    weak var presenter: FeelPresenter!
    
    private var dataSource: [ContentType: [ActivityContent]] = [:]
    private var emptyDataSource: [ContentType: [ActivityContent]] = [:]
    private var count = 0
    var startTime : CFAbsoluteTime!
    
    required init(presenter: Presenter) {
        self.presenter = presenter
    }
    
    func input(_ inputCase: FeelInteractorInput) {
        switch inputCase {
        case .prepareTracks(content: let content):
            prepareTracks(for: content)
        case .prepareDataSource(contentTypeArray: let contentTypes, completion: let completion):
            startTime = CFAbsoluteTimeGetCurrent()
            count = contentTypes.count
            createEmptyDataSource(contentTypes: contentTypes)
            dataSource = [:]
            prepareDataSource(contentTypeArray: contentTypes, completion: completion)
//        case .downloadContent(let content):
//            DataSource.shared.saveContent(content: content, isHidden: true)
        }
    }
    
    private func prepareTracks(for content: ActivityContent) {
        AudioService.shared.config(fullImage: content.imageURL, smallImage: content.smallImageURL, tracks: content.audioTracks)
    }
    
    private func createEmptyDataSource(contentTypes: [ContentType]) {
        emptyDataSource = [:]
        for contentType in contentTypes {
            emptyDataSource[contentType] = []
        }
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
                if type == .quote {
                    self.dataSource[type] = content
                }else {
                    let filterArray = content.filter { (content) -> Bool in
                        return content.forCategoryPresentation == true
                    }
                    self.dataSource[type] = filterArray
                }
            }
            if self.dataSource.keys.count == self.count {
                if self.dataSource.keys.isEmpty {
                    completion?(self.emptyDataSource)
                } else {
                    let timeElapsed = CFAbsoluteTimeGetCurrent() -  self.startTime
                    print("timer = \(timeElapsed)")
                    completion?(self.dataSource)
                }
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
