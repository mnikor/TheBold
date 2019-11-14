//
//  SettingsInteractor.swift
//  Bold
//
//  Created by Anton Klysa on 8/16/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation

enum SettingsInteractorInput {
    case putInitialValue(SettingsCellType,Bool)
    case getInitialValue(SettingsCellType, (Bool)->())
}

protocol SettingsInteractorInputProtocol: InteractorProtocol {
    func input(_ inputCase: SettingsInteractorInput)
}

class SettingsInteractor: SettingsInteractorInputProtocol {
    
    
    //MARK: InteractorProtocol
    
    typealias Presenter = SettingsPresenter
    
    weak var presenter: SettingsPresenter!
    
    
    //MARK: init
    
    required init(presenter: Presenter) {
        self.presenter = presenter
    }
    
    
    //MARK: SettingsInteractorInputProtocol
    
    func input(_ inputCase: SettingsInteractorInput) {
        switch inputCase {
        case .getInitialValue(let cellType, let completion):
            let value: Bool
            switch cellType {
            case .iosCalendar:
                value = SettingsService.shared.syncWithIOSCalendar
            case .iCloud:
                value = SettingsService.shared.syncWithICloud
            case .onWifi:
                value = SettingsService.shared.downloadOnWiFiOnly
            default:
                value = UserDefaults.standard.bool(forKey: cellType.rawValue)
            }
            completion(value)
        case .putInitialValue(let cellType, let value):
            switch cellType {
            case .iosCalendar:
                SettingsService.shared.syncWithIOSCalendar = value
            case .iCloud:
                SettingsService.shared.syncWithICloud = value
            case .onWifi:
                SettingsService.shared.downloadOnWiFiOnly = value
            default:
                UserDefaults.standard.set(value, forKey: cellType.rawValue)
            }
        }
    }
}
