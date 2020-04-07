//
//  ActionsListInteractor.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/22/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation

enum ActionsListInteractorInput {
    case prepareDataSource(contentType: ContentType, completion: (([ActivityContent], [ActivityGroup]) -> Void))
    case downloadContent(content: ActivityContent, isHidden: Bool)
}

protocol ActionsListInteractorInputProtocol: InteractorProtocol {
    func input(_ inputCase: ActionsListInteractorInput)
}

class ActionsListInteractor: ActionsListInteractorInputProtocol {
    
    typealias Presenter = ActionsListPresenter
    
    weak var presenter: ActionsListPresenter!
    let dispatchGroup = DispatchGroup()
    
    required init(presenter: Presenter) {
        self.presenter = presenter
    }
    
    func input(_ inputCase: ActionsListInteractorInput) {
        switch inputCase {
        case .prepareDataSource(contentType: let type, completion: let completion):
            prepareDataSource(contentType: type, completion: completion)
        case .downloadContent(content: let content, isHidden: let isHidden):
            DataSource.shared.saveContent(content: content, isHidden: isHidden)
        }
    }
    
    private func prepareDataSource(contentType: ContentType, completion: (([ActivityContent], [ActivityGroup]) -> Void)?) {
        
        var contentsDG : [ActivityContent] = []
        var groupsDG : [ActivityGroup] = []
        
        DispatchQueue.main.async {
            
            self.dispatchGroup.enter()
            NetworkService.shared.getAllGroup(with: contentType) { (result) in
                switch result {
                case .failure(_):
                    self.dispatchGroup.leave()
                    break
                case .success(let groups):
                    groupsDG = groups
                    self.dispatchGroup.leave()
                    break
                }
            }
            
            self.dispatchGroup.enter()
            NetworkService.shared.getContent(with: contentType) { result in
                switch result {
                case .failure(_):
                    self.dispatchGroup.leave()
                    break
                case .success(let content):
                    //completion?(content)
                    contentsDG = content
                    self.dispatchGroup.leave()
                }
            }
            
            self.dispatchGroup.notify(queue: .main) {
                print("contents = \(contentsDG.count) groups = \(groupsDG.count)")
                
//                let allActions = contentsDG + groupsDG
//                let arrayTMP = allActions.sorted { (lhs, rhs) -> Bool in
//                    return lhs.position < rhs.position
//                }
                
                completion?(contentsDG, groupsDG)
            }
        }
    }
    
}
