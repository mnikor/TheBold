//
//  ActionsListPresenter.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/22/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation

enum ActionsListPresenterInput {
    case back
    case info
    case unlockActionCard
    case share
    case download
    case like
    case addActionPlan
    case start
    case unlockListenPreview
    case unlockReadPreview
    case listenPreview
    case readPreview
}

protocol ActionsListPresenterProtocol {
    func input(_ inputCase: ActionsListPresenterInput)
}

class ActionsListPresenter: PresenterProtocol, ActionsListPresenterProtocol {
    
    typealias View = ActionsListViewController
    typealias Interactor = ActionsListInteractor
    typealias Router = ActionsListRouter
    
    weak var viewController: ActionsListViewController!
    var interactor: ActionsListInteractor!
    var router: ActionsListRouter!
    
    lazy var actions : [ActionEntity] = {
        return [ActionEntity(type: .action, header: .duration, download: true, like: true),
                ActionEntity(type: .action, header: .points, download: false, like: false),
                ActionEntity(type: .action, header: .unlock, download: false, like: false),
                ActionEntity(type: .manageIt, header: nil, download: false, like: false),
                ActionEntity(type: .action, header: .unlock, download: false, like: false),
                ActionEntity(type: .action, header: .unlock, download: false, like: false),
                ActionEntity(type: .songOrListen, header: nil, download: false, like: false)
        ]
    }()
    
    required init(view: View) {
        self.viewController = view
    }
    
    required init?(coder aDecoder: NSCoder) {
        
    }
    
    func input(_ inputCase: ActionsListPresenterInput) {
        
        switch inputCase {
        case .back:
            router.input(.back)
        case .info:
            router.input(.info)
        case .unlockActionCard:
            print("dsf")
        case .share:
            viewController.shareContent(item: nil)
        case .download:
            print("dow")
        case .like:
            print("dsf")
        case .addActionPlan:
            let vc = AddActionPlanViewController.createController {
                print("create add action")
            }
            router.input(.presentedBy(vc))
        case .start:
            print("Start")
        case .unlockListenPreview:
            print("unlockListenPreview")
        case .unlockReadPreview:
            print("unlockReadPreview")
        case .listenPreview:
            print("listenPreview")
        case .readPreview:
            print("readPreview")
        }
    }
}


class ActionEntity: NSObject {
    var type : ActionCellType
    var header : HeaderType?
    var download : Bool
    var like : Bool
    
    init(type: ActionCellType, header: HeaderType?, download: Bool, like: Bool) {
        self.type = type
        self.header = header
        self.download = download
        self.like = like
    }
}
