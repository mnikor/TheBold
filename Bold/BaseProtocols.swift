//
//  BaseProtocols.swift
//  Bold
//
//  Created by Alexander Kovalov on 5/28/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation

protocol ViewProtocol: class {
    associatedtype Presenter
    associatedtype Configurator
    
    var presenter: Presenter! {get set}
    var configurator: Configurator! {get set}
}

protocol PresenterProtocol: class {
    associatedtype View
    associatedtype Interactor
    associatedtype Router
    
    var viewController: View! {get set}
    var interactor: Interactor! {get set}
    var router: Router! {get set}
    
    init(view: View)
    init?(coder aDecoder: NSCoder)
}

protocol ConfiguratorProtocol: class {
    associatedtype View
    
    func configure(with viewController: View)
}

protocol InteractorProtocol: class {
    associatedtype Presenter
    
    var presenter: Presenter! {get set}
    
    init(presenter: Presenter)
}

protocol RouterProtocol: class {
    associatedtype View
    
    var viewController: View! {get set}
    
    init(viewController: View)
}
