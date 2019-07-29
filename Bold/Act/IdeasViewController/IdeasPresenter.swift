//
//  IdeasPresenter.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/26/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation

enum IdeasInputPresenter {
    case selectIdea
    case back
    case cancel
}

protocol IdeasInputPresenterProtocol: PresenterProtocol {
    func input(_ inputCase: IdeasInputPresenter)
    func item(for index: Int) -> IdeasType
    func itemsCount() -> Int
}

class IdeasPresenter: IdeasInputPresenterProtocol {
    
    typealias View = IdeasViewController
    typealias Interactor = IdeasInteractor
    typealias Router = IdeasRouter
    
    weak var viewController: View!
    var interactor: Interactor!
    var router: Router!
    
    lazy var ideas : [IdeasType] = {
        return [.marathon, .triathlon, .charityProject, .writeBook, .quitSmoking, .publicSpeech, .skyDiving, .launchStartUp, .competeToWin, .startNewProject, .killProject, .findNewJob, .makeDiscovery, .inventSomething, .income, .masterSkill]
    }()
    
    required init(view: View) {
        self.viewController = view
    }
    
    required init?(coder aDecoder: NSCoder) {
    }
    
    func input(_ inputCase: IdeasInputPresenter) {
        switch inputCase {
        case .selectIdea:
            print("select")
        case .cancel:
            router.input(.cancel)
        case .back:
            router.input(.back)
        }
    }
    
    func itemsCount() -> Int {
        return ideas.count
    }
    
    func item(for index: Int) -> IdeasType {
        guard index >= 0 && index < ideas.count else {
            fatalError()
        }
        return ideas[index]
    }
    
}
