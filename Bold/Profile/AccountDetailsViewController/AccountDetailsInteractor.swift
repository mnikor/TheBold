//
//  AccountDetailsInteractor.swift
//  Bold
//
//  Created by Admin on 8/15/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation

enum AccountDetailsInteractorInput {
    case prepareDataSource(([AccountDetailsItem: ButtonedTitleViewModel]) -> Void)
    case updateItem((itemForUpdate: (item: AccountDetailsItem, value: String?) , completion: (_ item: AccountDetailsItem, _ viewModel: ButtonedTitleViewModel) -> Void))
}

protocol AccountDetailsInteractorInputProtocol: InteractorProtocol {
    func input(_ inputCase: AccountDetailsInteractorInput)
}

class AccountDetailsInteractor: AccountDetailsInteractorInputProtocol {
    typealias Presenter = AccountDetailsPresenter
    
    weak var presenter: Presenter!
    
    var dataSource: [AccountDetailsItem: String] = [.firstName: "Johnathan",
                                                    .lastName: "Smith",
                                                    .email: "johnsmith@gmail.com",
                                                    .password: "Connected with Facebook"]
    
    required init(presenter: Presenter) {
        self.presenter = presenter
    }
    
    func input(_ inputCase: AccountDetailsInteractorInput) {
        switch inputCase {
        case .prepareDataSource(let completion):
            completion(prepareDataSource())
        case .updateItem(itemForUpdate: let item, completion: let completion):
            let newDataSourceItem = updateItem(item.item, with: item.value)
            completion(newDataSourceItem.item, newDataSourceItem.viewModel)
        }
    }
    
    private func prepareDataSource() -> [AccountDetailsItem: ButtonedTitleViewModel] {
        var dataSource = [AccountDetailsItem: ButtonedTitleViewModel]()
        AccountDetailsItem.allCases.forEach { [weak self] item in
            self?.dataSource[item] = self?.dataSource[item] ?? item.rawValue
            dataSource[item] = ButtonedTitleViewModel(title: self?.dataSource[item] ?? item.rawValue,
                                                            buttonTitle: "Edit")
        }
        return dataSource
    }
    
    private func updateItem(_ item: AccountDetailsItem, with value: String?) -> (item: AccountDetailsItem, viewModel: ButtonedTitleViewModel) {
        dataSource[item] = value
        let viewModel = ButtonedTitleViewModel(title: value,
                                               buttonTitle: "Edit")
        return (item, viewModel)
    }
    
}
