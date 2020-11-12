//
//  ActionsListPresenter.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/22/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

enum ActionsListPresenterInput {
    case prepareDataSource(type: FeelTypeCell, completion: (([ActionEntity]) -> Void))
    case back
    case info(FeelTypeCell)
    case unlockActionCard(ActivityContent)
    case share(ActionEntity)
    case systemShare(UIImage, String)
    case download(ActivityContent)
    case like
    case addActionPlan(ActivityContent)
    case tappedContentInGroup(pressType: GroupContentButtonPressType, content: ActivityContent)
    case didSelectContent(ActivityContent)
    case subscribeToUpdate
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
    
    private let disposeBag = DisposeBag()
    
    required init(view: View) {
        self.viewController = view
    }
    
    required init?(coder aDecoder: NSCoder) {
        
    }
    
    func input(_ inputCase: ActionsListPresenterInput) {
        
        switch inputCase {
        case .prepareDataSource(type: let type, completion: let completion):
            prepareDataSource(type: type, completion: completion)
        case .back:
            router.input(.back)
        case .info(let type):
            router.input(.info(type))
        case .unlockActionCard(let content):
            unlockActionCard(content)
        case .share(let action):
            router.input(.share(action))
        case .systemShare(let image, let type):
            let title = "Hey, I recommend to listen this \(type)"
            let link = URL(string: GlobalConstants.appURL)!
            router.input(.systemShare([title, image, link]))
        case .download(let content):
            interactor.input(.downloadContent(content: content, isHidden: false))
        case .like:
            print("dsf")
        case .addActionPlan(let content):
            
            AlertViewService.shared.input(.addAction(content: content, tapAddPlan: {
                
            }))
            
//            let vc = AddActionPlanViewController.createController {
//                print("create add action")
//            }
//            vc.contentID = String(content.id)
//            interactor.input(.downloadContent(content: content, isHidden: true))
//            router.input(.presentedBy(vc))

        case .tappedContentInGroup(pressType: let pressType, content: let content):
            tappedOnButtonOfContentInGroup(pressType: pressType, content: content)
        case .didSelectContent(let content):
            switch content.type {
            case .lesson, .story:
//                increaseBoldnessCounter()
                router.input(.read(content))
            default:
                router.input(.player(content))
            }
        case .subscribeToUpdate:
            subscribeToChangePremium()
        }
    }
    
    private func unlockActionCard(_ content: ActivityContent) {
        if content.contentStatus == .locked {
            router.input(.showPremium)
        } else {
            router.showLockedByPointsController()
        }
        
//        print("\(content)")
//
//        let user = DataSource.shared.readUser()
//
//        if user.levelOfMasteryPoints > content.pointOfUnlock {
//            content.contentStatus = .unlocked
//            user.levelOfMasteryPoints = user.levelOfMasteryPoints - Int32(content.pointOfUnlock)
//            //DataSource.shared.saveBackgroundContext()
//            interactor.input(.downloadContent(content: content, isHidden: false))
//        }else {
//            print("not points")
//        }
        print("Unlock")
    }
    
    private func tappedOnButtonOfContentInGroup(pressType: GroupContentButtonPressType, content: ActivityContent) {
        
        switch pressType {
        case .previewListen:
            router.input(.listenPreview(content))
        case .previewRead:
            router.input(.readPreview(content))
        case .start:
            self.input(.didSelectContent(content))
        case .unlock:
            self.input(.unlockActionCard(content))
        case .addToPlan:
            self.input(.addActionPlan(content))
        }
    }
    
    private func prepareDataSource(type: FeelTypeCell, completion: (([ActionEntity]) -> Void)?) {
        interactor.input(.prepareDataSource(contentType: getContentType(by: type)) { (content, group) in
            
            ActionEntity.constructObjects(type: type, content: content, group: group, completion: completion)
            
//            var allActions = content + group
//            allActions = allActions.sorted { (lhs, rhs) -> Bool in
//                return lhs.id < rhs.id
//            }
//
//            let actions: [ActionEntity] = allActions.compactMap { activityContent in
//
//                if let group = activityContent as? ActivityGroup {
//                    return ActionEntity(type: .manageIt,
//                                        header: .duration,
//                                        download: false,
//                                        like: false,
//                                        group: group)
//                }
//
//                if let content = activityContent as? ActivityContent {
//
//                    if let savedContent = DataSource.shared.fetchContent(activityContent: content),
//                        !savedContent.isHidden,
//                        let savedActivityContent = ActivityContent.map(content: savedContent) {
//                        return ActionEntity(type: .action,
//                                            header: .duration ,
//                                            download: true,
//                                            like: false,
//                                            data: savedActivityContent)
//                    }
//
//                    let type: HeaderType = content.contentStatus == .locked ? .unlock : (content.pointOfUnlock > 0 ? .points : .duration)
//                    return ActionEntity(type: .action,
//                                        header: type,
//                                        download: false,
//                                        like: false,
//                                        data: content)
//                }
//                return nil
//            }
//            completion?(actions)
        })
    }
    
    private func getContentType(by type: FeelTypeCell) -> ContentType {
        switch type {
        case .citate:
            return .quote
        case .hypnosis:
            return .hypnosis
        case .lessons:
            return .lesson
        case .meditation:
            return .meditation
        case .pepTalk:
            return .peptalk
        case .stories:
            return .story
        }
    }
    
    private func subscribeToChangePremium() {
        
        DataSource.shared.changePremium.subscribe(onNext: {[weak self] (isPremium) in
            
            print("++++++++++PREMIUM STATUS ActionListPresenter = \(isPremium)")
            
            guard let ss = self else {return}
            
            for itemHeader in ss.viewController.actions {
                
                itemHeader.data?.calculateStatus()
                
                switch itemHeader.data?.contentStatus {
                case .locked:
                    itemHeader.header = .unlock
                case .lockedPoints:
                    itemHeader.header = .points
                default:
                    itemHeader.header = .duration
                }
                
                if let group = itemHeader.group {
                    
                    for itemCell in group.contentObjects {
                        itemCell.calculateStatus()
                    }
                }
            }
            ss.viewController.tableView.reloadData()
                        
        }).disposed(by: disposeBag)
    }
    
}

class ActionEntity: NSObject {
    var type : ActionCellType
    var header : HeaderTypeCell?
    var download : Bool
    var like : Bool
    var data: ActivityContent?
    var group: ActivityGroup?
    
    init(type: ActionCellType, header: HeaderTypeCell?, download: Bool, like: Bool, data: ActivityContent? = nil, group: ActivityGroup? = nil) {
        self.type = type
        self.header = header
        self.download = download
        self.like = like
        self.data = data
        self.group = group
    }
    
    class func constructObjects(type: FeelTypeCell, content: [ActivityContent], group: [ActivityGroup], completion: (([ActionEntity]) -> Void)?) {
            
            var allActions = content + group
            allActions = allActions.sorted { (lhs, rhs) -> Bool in
                return lhs.position < rhs.position
            }
            
            let actions: [ActionEntity] = allActions.compactMap { activityContent in
                
                if let group = activityContent as? ActivityGroup {
                    return ActionEntity(type: .group,
                                        header: .duration,
                                        download: false,
                                        like: false,
                                        group: group)
                }
                
                if let content = activityContent as? ActivityContent {
                    
                    if let savedContent = DataSource.shared.fetchContent(activityContent: content),
                        !savedContent.isHidden,
                        let savedActivityContent = ActivityContent.map(content: savedContent) {
                        return ActionEntity(type: .action,
                                            header: .duration ,
                                            download: true,
                                            like: false,
                                            data: savedActivityContent)
                    }
                    
                    let type: HeaderTypeCell!
                    
                    switch content.contentStatus {
                    case .locked:
                        type = .unlock
                    case .lockedPoints:
                        type = .points
                    default:
                        type = .duration
                    }
                    
//                    let type: HeaderType = content.contentStatus == .locked ? .unlock : (content.pointOfUnlock > 0 ? .points : .duration)
                    
                    return ActionEntity(type: .action,
                                        header: type,
                                        download: false,
                                        like: false,
                                        data: content)
                }
                return nil
            }
        
            completion?(actions)
    }
    
}
