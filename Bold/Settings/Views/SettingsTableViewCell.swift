//
//  SettingsTableViewCell.swift
//  Bold
//
//  Created by Anton Klysa on 8/16/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation
import UIKit

class SettingsTableViewCell: BaseTableViewCell {
    
    //MARK: IBOutlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var toggleSwitch: UISwitch!
    @IBOutlet weak var arrowImage: UIImageView!
    
    //MARK: props
    
    private var model: SettingsModel!
    private var toggleAction: ((Bool, SettingsCellType)->())?
    private var cellType: SettingsCellType!
    
    //MARK: setup cell
    
    func setupCell(model: SettingsModel, toggleAction: ((Bool, SettingsCellType)->())?) {
        self.model = model
        self.cellType = model.cellType
        self.toggleAction = toggleAction
        switch model.accessoryType {
        case .arrow:
            toggleSwitch.isHidden = true
        case .toggle:
            arrowImage.isHidden = true
            toggleSwitch.isOn = model.toggleInitialValue
        case .none:
            toggleSwitch.isHidden = true
            arrowImage.isHidden = true
        }
        titleLabel.textAlignment = .left
        titleLabel.text = model.title
        titleLabel.font = UIFont(font: FontFamily.MontserratMedium.regular, size: 12)
        
        if model.cellType == .signOut {
            titleLabel.textColor = .red
            titleLabel.textAlignment = .center
        }
    }
    
    
    //MARK: IBOutlet actions
    
    @IBAction private func toggleSwitchAction(sender: UISwitch) {
        guard toggleAction != nil else {
            return
        }
        toggleAction!(toggleSwitch.isOn, cellType)
    }
}
