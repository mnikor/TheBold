//
//  BlueNavigationBar.swift
//  Bold
//
//  Created by Alexander Kovalov on 8/13/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

enum NavBarCreateType {
    case action
    case goal
    
    var title : String {
        switch self {
        case .action:
            return L10n.Act.Create.actionTitle
        case .goal:
            return L10n.Act.Create.goalHeader
        }
    }
}

class BlueNavigationBar: UINavigationBar {

    typealias block = (() -> Void)
    
    var tapSave: block?
    var tapCancel: block?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonSetup()
    }

    private func commonSetup() {
        delegate = self
        isTranslucent = false
        barTintColor = ColorName.primaryBlue.color
        tintColor = .white
        titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        shadowImage = UIImage()
        topItem?.backBarButtonItem = UIBarButtonItem(title: L10n.cancel, style: .plain, target: nil, action: nil)
        createButtons()
    }
    
    private func createButtons() {
        let saveButton = UIBarButtonItem(title: L10n.save, style: .plain, target: self, action: #selector(tapSaveButton))
        topItem?.rightBarButtonItem = saveButton
        let cancelButton = UIBarButtonItem(title: L10n.cancel, style: .plain, target: self, action: #selector(tapCancelButton))
        topItem?.leftBarButtonItem = cancelButton
    }
    
    @objc func tapSaveButton() {
        self.tapSave?()
    }
    
    @objc func tapCancelButton() {
        self.tapCancel?()
    }
    
    func configure(type: NavBarCreateType, save: @escaping block, cancel: @escaping block) {
        
        topItem?.rightBarButtonItem?.isEnabled = false
        tapSave = save
        tapCancel = cancel
        topItem?.title = type.title
    }
}

extension BlueNavigationBar: UINavigationBarDelegate {
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}
