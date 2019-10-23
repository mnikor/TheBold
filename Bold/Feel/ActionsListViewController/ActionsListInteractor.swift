//
//  ActionsListInteractor.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/22/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation

enum ActionsListInteractorInput {
    case prepareDataSource(contentType: ContentType, completion: (([Content]) -> Void))
}

protocol ActionsListInteractorInputProtocol: InteractorProtocol {
    func input(_ inputCase: ActionsListInteractorInput)
}

class ActionsListInteractor: ActionsListInteractorInputProtocol {
    
    typealias Presenter = ActionsListPresenter
    
    weak var presenter: ActionsListPresenter!
    
    required init(presenter: Presenter) {
        self.presenter = presenter
    }
    
    func input(_ inputCase: ActionsListInteractorInput) {
        switch inputCase {
        case .prepareDataSource(contentType: let type, completion: let completion):
            prepareDataSource(contentType: type, completion: completion)
        }
    }
    
    private func prepareDataSource(contentType: ContentType, completion: (([Content]) -> Void)?) {
        NetworkService.shared.getContent(with: contentType) { result in
            switch result {
            case .failure(let error):
                break
            case .success(let content):
                completion?(content)
            }
        }
    }
    
}
