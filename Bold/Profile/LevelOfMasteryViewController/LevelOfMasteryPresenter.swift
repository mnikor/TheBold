//
//  LevelOfMasteryPresenter.swift
//  Bold
//
//  Created by Alexander Kovalov on 8/27/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation
import UIKit

enum LevelOfMasteryPresenterInput {
    case close
}

protocol LevelOfMasteryInputProtocol: PresenterProtocol {
    func input(_ inputCase: LevelOfMasteryPresenterInput)
}

class LevelOfMasteryPresenter: LevelOfMasteryInputProtocol {
    
    typealias View = LevelOfMasteryViewController
    typealias Interactor = LevelOfMasteryInteractor
    typealias Router = LevelOfMasteryRouter
    
    weak var viewController: View!
    var interactor: Interactor!
    var router: Router!
    
    required init?(coder aDecoder: NSCoder) {
        
    }
    
    required init(view: View) {
        self.viewController = view
    }
    
    func input(_ inputCase: LevelOfMasteryPresenterInput) {
        switch inputCase {
        case .close:
            router.input(.close)
        }
    }
    
    
    
    
    
    
}

