//
//  DownloadsInteractor.swift
//  Bold
//
//  Created by Alexander Kovalov on 8/27/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation

enum DownloadsInteractorInput {
    case prepareDataSource(completion: (([ActivityContent]) -> Void))
}

protocol DownloadsInteractorInputProtocol: InteractorProtocol {
    func input(_ inputCase: DownloadsInteractorInput)
}

class DownloadsInteractor: DownloadsInteractorInputProtocol {
    
    typealias Presenter = DownloadsPresenter
    
    weak var presenter: Presenter!
    
    required init(presenter: Presenter) {
        self.presenter = presenter
    }
    
    func input(_ inputCase: DownloadsInteractorInput) {
        switch inputCase {
        case .prepareDataSource(completion: let completion):
            prepareDataSource(completion: completion)
        }
    }
    
    private func prepareDataSource(completion: (([ActivityContent]) -> Void)?) {
        completion?(DataSource.shared.contentList().filter({ !$0.isHidden }).compactMap { ActivityContent.map(content: $0) })
    }
}
