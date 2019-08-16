//
//  ProfilePresenter.swift
//  Bold
//
//  Created by Admin on 8/14/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

enum ProfilePresenterInput {
    case prepareDataSource(([UserProfileDataSourceItem]) -> Void)
    case profileInfo
    case accountDetails
    case archivedGoals
    case downloads
    case calendar
    case rateApp
    case logout
}

protocol ProfilePresenterInputProtocol: PresenterProtocol {
    func input(_ inputCase: ProfilePresenterInput)
}

class ProfilePresenter: ProfilePresenterInputProtocol {
    typealias View = ProfileViewController
    typealias Interactor = ProfileInteractor
    typealias Router = ProfileRouter
    
    weak var viewController: View!
    var interactor: Interactor!
    var router: Router!
    
    required init(view: View) {
        viewController = view
    }
    
    required init?(coder aDecoder: NSCoder) {
        
    }
    
    func input(_ inputCase: ProfilePresenterInput) {
        switch inputCase {
        case .prepareDataSource(let completion):
            interactor.input(.prepareDataSource(completion))
        case .profileInfo:
            profileInfo()
        case .accountDetails:
            accountDetails()
        case .archivedGoals:
            archivedGoals()
        case .downloads:
            downloads()
        case .calendar:
            calendar()
        case .rateApp:
            rateApp()
        case .logout:
            logout()
        }
    }
    
    private func profileInfo() {
        // TODO
    }
    
    private func accountDetails() {
        router.input(.performSegue(segueType: .showAccountDetails))
    }
    
    private func archivedGoals() {
        // TODO
    }
    
    private func downloads() {
        // TODO
    }
    
    private func calendar() {
        router.input(.performSegue(segueType: .showCalendarAndHistoryIdentifier))
        // TODO
    }
    
    private func rateApp() {
        // TODO
    }
    
    private func logout() {
        // TODO
    }
    
}
