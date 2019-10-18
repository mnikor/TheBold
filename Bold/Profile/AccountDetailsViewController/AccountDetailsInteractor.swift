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
    
    var dataSource: [AccountDetailsItem: ButtonedTitleViewModel] = [:]
    
    required init(presenter: Presenter) {
        self.presenter = presenter
    }
    
    func input(_ inputCase: AccountDetailsInteractorInput) {
        switch inputCase {
        case .prepareDataSource(let completion):
            completion(prepareDataSource())
        case .updateItem(itemForUpdate: let item, completion: let completion):
            updateItem(item.item, with: item.value, completion: completion)
        }
    }
    
    private func prepareDataSource() -> [AccountDetailsItem: ButtonedTitleViewModel] {
        let profile = SessionManager.shared.profile
        dataSource[.firstName] = ButtonedTitleViewModel(title: profile?.firstName ?? AccountDetailsItem.firstName.rawValue,
                                                        buttonTitle: "Edit")
        dataSource[.lastName] = ButtonedTitleViewModel(title: profile?.lastName ?? AccountDetailsItem.lastName.rawValue,
                                                       buttonTitle: "Edit")
        dataSource[.email] = ButtonedTitleViewModel(title: profile?.email,
                                                    buttonTitle: "Edit")
        dataSource[.password] = ButtonedTitleViewModel(title: "Connected with Facebook",
                                                       buttonTitle: "Edit")
        return dataSource
    }
    
    private func updateItem(_ item: AccountDetailsItem, with value: String?, completion: ((_ item: AccountDetailsItem, _ viewModel: ButtonedTitleViewModel) -> Void)?) {
        guard var profile = SessionManager.shared.profile else { return }
        switch item {
        case .firstName:
            profile.firstName = value
        case .lastName:
            profile.lastName = value
        case .email:
            profile.email = value ?? profile.email
        default:
            break
        }
        NetworkService.shared.editProfile(firstName: profile.firstName, lastName: profile.lastName, image: nil) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                // add error handling
                break
            case .success(let profile):
                SessionManager.shared.profile = profile
                let viewModel = ButtonedTitleViewModel(title: value,
                                                       buttonTitle: "Edit")
                self.dataSource[item] = viewModel
                completion?(item, viewModel)
            }
        }
    }
    
}
