//
//  AccountDetailsPresenter.swift
//  Bold
//
//  Created by Admin on 8/15/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

enum AccountDetailsPresenterInput {
    case prepareDataSource(([AccountDetailsItem: ButtonedTitleViewModel]) -> Void)
    case edit(item: AccountDetailsItem)
    case back
    case prepareFor(segue: UIStoryboardSegue, sender: (item: AccountDetailsItem, value: String))
    case updateItem(item: AccountDetailsItem, value: String?)
}

protocol AccountDetailsPresenterInputProtocol: PresenterProtocol {
    func input(_ inputCase: AccountDetailsPresenterInput)
}

class AccountDetailsPresenter: AccountDetailsPresenterInputProtocol {
    typealias View = AccountDetailsViewController
    typealias Interactor = AccountDetailsInteractor
    typealias Router = AccountDetailsRouter
    
    weak var viewController: View!
    var interactor: Interactor!
    var router: Router!
    
    required init(view: View) {
        viewController = view
    }
    
    required init?(coder aDecoder: NSCoder) {
        
    }
    
    func input(_ inputCase: AccountDetailsPresenterInput) {
        switch inputCase {
        case .prepareDataSource(let completion):
            interactor.input(.prepareDataSource(completion))
        case .edit(item: let item):
            edit(item: item)
        case .back:
            back()
        case .prepareFor(segue: let segue, sender: let sender):
            prepare(for: segue, sender: sender)
        case .updateItem(item: let item, value: let value):
            updateItem(item, value: value)
        }
    }
    
    private func edit(item: AccountDetailsItem) {
        router.input(.performSegue(segue: .editItem, sender: item))
    }
    
    private func back() {
        router.input(.pop)
    }
    
    private func prepare(for segue: UIStoryboardSegue, sender: (item: AccountDetailsItem, value: String)) {
        guard let editDetailsVC = segue.destination as? EditAccountDetailsViewController
            else { return }
        editDetailsVC.item = sender.item
        editDetailsVC.value = sender.value
        editDetailsVC.delegate = viewController
    }
    
    private func updateItem(_ item: AccountDetailsItem, value: String?) {
        interactor.input(.updateItem((itemForUpdate: (item: item, value: value),
                                      completion: { [weak self] item, viewModel in self?.viewController.input(.updateCell(item: item, viewModel: viewModel)) })))
    }
    
}
