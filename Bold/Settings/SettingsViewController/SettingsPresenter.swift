//
//  SettingsPresenter.swift
//  Bold
//
//  Created by Anton Klysa on 8/16/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation

enum SettingsPresenterInput {
    
    case setupDataSource(()->())
    case putInitialValue(SettingsCellType,Bool)
    case signOut
    
    case present(SettingsCellType)
    case showMenu
}

protocol SettingsPresenterInputProtocol: PresenterProtocol {
    
    func input(_ case: SettingsPresenterInput)
    
    var tableViewDataSource: [SettingsSectionModel]! { get }
}

class SettingsPresenter: SettingsPresenterInputProtocol {
    
    //MARK: props
    
    var tableViewDataSource: [SettingsSectionModel]!
        
    
    //MARK: PresenterProtocol
    
    typealias View = SettingsViewController
    typealias Interactor = SettingsInteractor
    typealias Router = SettingsRouter
    
    var interactor: Interactor!
    var router: Router!
    weak var viewController: View!
    
    
    //MARK: init
    
    required init(view: View) {
        self.viewController = view
    }
    
    required init?(coder aDecoder: NSCoder) {
        
    }
    
    
    //MARK: SettingsPresenterInputProtocol
    
    func input(_ inputCase: SettingsPresenterInput) {
        switch inputCase {
        case .signOut:
            //TODO:
            break
        case .present(let cellType):
            router.input(.present(cellType))
        case .showMenu:
            router.input(.showMenu)
        case .putInitialValue(let cellType, let value):
            putInitialValue(for: cellType, value: value)
        case .setupDataSource(let completion):
            tableViewDataSource = [
                SettingsSectionModel(header: nil, items: [
                    SettingsModel(title: L10n.Settings.premiumAccount, accessoryType: .arrow, cellType: .premium)
                    ]),
                SettingsSectionModel(header: L10n.Settings.synchronise, items: [
                    SettingsModel(title: L10n.Settings.iosCalendar, accessoryType: .toggle, toggleInitialValue: getInitialValue(for: .iosCalendar), cellType: .iosCalendar),
                    SettingsModel(title: L10n.Settings.googleCalendar, accessoryType: .toggle, toggleInitialValue: getInitialValue(for: .googleCalendar), cellType: .googleCalendar),
                    SettingsModel(title: L10n.Settings.inCloud, accessoryType: .toggle, toggleInitialValue: getInitialValue(for: .iCloud), cellType: .iCloud)
                    ]),
                SettingsSectionModel(header: L10n.Settings.offline, items: [
                    SettingsModel(title: L10n.Settings.onWIFI, accessoryType: .toggle, toggleInitialValue: getInitialValue(for: .onWifi), cellType: .onWifi)
                    ]),
                SettingsSectionModel(header: L10n.Settings.support, items: [
                    SettingsModel(title: L10n.Settings.terms, accessoryType: .arrow, cellType: .terms),
                    SettingsModel(title: L10n.Settings.privacy, accessoryType: .arrow, cellType: .privacy),
                    SettingsModel(title: L10n.Settings.version, cellType: .version)
                    ]),
                SettingsSectionModel(header: nil, items: [
                    SettingsModel(title: L10n.Settings.signOut, cellType: .signOut)
                    ])
            ]
            completion()
        }
    }
    
    
    //MARK: private actions
    
    private func getInitialValue(for cellType: SettingsCellType) -> Bool {
        
        var aBool: Bool = false
        
        let queue = DispatchGroup()
        objc_sync_enter(queue)
        interactor.input(.getInitialValue(cellType, { (bool) in
            aBool = bool
        }))
        objc_sync_exit(queue)
        return aBool
    }
    
    private func putInitialValue(for cellType: SettingsCellType, value: Bool) {
        interactor.input(.putInitialValue(cellType, value))
    }
}
