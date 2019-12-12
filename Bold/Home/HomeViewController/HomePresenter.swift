//
//  HomePresenter.swift
//  Bold
//
//  Created by Alexander Kovalov on 6/14/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

enum HomePresenterInput {
    case prepareDataSource(([ActivityViewModel]) -> Void)
    case menuShow
    case actionAll(HomeActionsTypeCell)
    case actionItem(ActivityViewModel, Int)
    case unlockBoldManifest
    case createGoal
    case subscribeForUpdates
}

protocol HomePresenterInputProtocol {
    func input(_ inputCase: HomePresenterInput)
}

class HomePresenter: PresenterProtocol, HomePresenterInputProtocol {
    
    typealias View = HomeViewController
    typealias Interactor = HomeInteractor
    typealias Router = HomeRouter
    
    weak var viewController: View!
    var interactor: Interactor!
    var router: Router!
    
    private var disposeBag = DisposeBag()
    
    required init(view: View) {
        self.viewController = view
    }
    
    required init?(coder aDecoder: NSCoder) {
    }
    
    func input(_ inputCase: HomePresenterInput) {
        
        switch inputCase {
        case .prepareDataSource(let completion):
            interactor.input(.prepareDataSource(completion))
        case .menuShow:
            router.input(.menuShow)
        case .actionAll(let type):
            router.input(.actionAll(type))
        case .actionItem(let viewModel, let index):
            actionItem(viewModel: viewModel, at: index)
        case .unlockBoldManifest:
            router.input(.unlockBoldManifest)
        case .createGoal:
            router.input(.createGoal)
        case .subscribeForUpdates:
            subscribeForUpdates()
        }
    }
    
    private func actionItem(viewModel: ActivityViewModel, at index: Int) {
        interactor.input(.getFeelType(type: viewModel.type, index: index, completion: { [weak self] feelType in
            guard let feelType = feelType else { return }
            self?.router.input(.actionItem(feelType))
        }))
    }
    
    private func subscribeForUpdates() {
        DataSource.shared.changeContext.subscribe(onNext: {[weak self] (_) in
            self?.viewController.input(.goalsUpdated)
        }).disposed(by: disposeBag)
    }
    
}


