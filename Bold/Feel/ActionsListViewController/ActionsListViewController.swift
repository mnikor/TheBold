//
//  ActionsListViewController.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/1/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit
import SVProgressHUD

enum ActionCellType {
    case action
    case songOrListen
    case group
    
}

class ActionsListViewController: UIViewController, ViewProtocol {
    
    typealias Presenter = ActionsListPresenter
    typealias Configurator = ActionsListConfigurator
    
    var presenter: ActionsListPresenter!
    var configurator: ActionsListConfigurator! = ActionsListConfigurator()

    @IBOutlet weak var highNavigationBar: NavigationView!
    @IBOutlet weak var tableView: UITableView!
    
    var typeVC : FeelTypeCell = .meditation
    
    var actions: [ActionEntity] = []
    
    private var selectedContent: ActivityContent?
    
    private let loader = LoaderView(frame: .zero)
//    private var viewDidAppearAnimated: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configurator.configure(with: self)
        
        highNavigationBar.configItem(title: typeVC.titleText() ?? "", titleImage: .info, leftButton: .back, rightButton: .none)
        highNavigationBar.deleagte = self
        
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 60))
        registerXibs()
        prepareDataSource()
    }
    
    func registerXibs() {
        tableView.registerNib(ActionTableViewCell.self)
        tableView.registerNib(ListenOrReadTableViewCell.self)
        tableView.registerNib(ManageItTableViewCell.self)
        tableView.registerNib(NavigationTitleAndProgressTableViewCell.self)
    }
    
    private func prepareDataSource() {
        loader.start(in: self.view)
        presenter.input(.prepareDataSource(type: typeVC, completion: { [weak self] actions in
            self?.loader.stop()
            self?.actions = actions
            self?.tableView.reloadData()
        }))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        highNavigationBar.titleLabel.isHidden = true
        highNavigationBar.infoButton.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}


// MARK:- NavigationViewDelegate

extension ActionsListViewController: NavigationViewDelegate {
    
    func tapLeftButton() {
        presenter.input(.back)
    }
    
    @objc func tapInfoAction() {
        presenter.input(.info(typeVC))
    }
}


// MARK:- UITableViewDelegate, UITableViewDataSource

extension ActionsListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actions.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let headerCell = tableView.dequeReusableCell(indexPath: indexPath) as NavigationTitleAndProgressTableViewCell
            headerCell.titleLabel.text = typeVC.titleText() ?? ""
            headerCell.infoButton.isHidden = false
            headerCell.infoButton.addAction(self, action: #selector(tapInfoAction))
            headerCell.progressView.isHidden = true
            headerCell.progressViewHeight.constant = 0
            return headerCell
        } else {
            
            let content = actions[indexPath.row - 1]
            
            switch content.type {
            case .action:
                let cell = tableView.dequeReusableCell(indexPath: indexPath) as ActionTableViewCell
                cell.config(item: content)
                cell.delegate = self
                return cell
            case .songOrListen:
                let cell = tableView.dequeReusableCell(indexPath: indexPath) as ListenOrReadTableViewCell
                //            cell.config(content: content, type: .unlockListenPreview)
                return cell
            case .group:
                let cell = tableView.dequeReusableCell(indexPath: indexPath) as ManageItTableViewCell
                var type = TypeManageItCell.baseStaticCells
                if content.group!.contentObjects.count >= 3 {
                    type = .titleAndScroll
                }
                cell.config(type: type, group: content.group)
                cell.delegate = self
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: false)
            
            guard let content = actions[indexPath.row - 1].data else { return }
            
            selectedContent = content
            presenter.input(.didSelectContent(content))
    //        switch content.type {
    //        case .lesson, .story:
    //            let vc = StoryboardScene.Description.descriptionAndLikesCountViewController.instantiate()
    //            vc.viewModel = DescriptionViewModel.map(activityContent: content)
    //            vc.isDownloadedContent = DataSource.shared.contains(content: content)
    //            navigationController?.present(vc, animated: true, completion: nil)
    //        default:
    //
    //            PlayerViewController.createController(content: content)
    //        }
            
    //        if actions[indexPath.row].type == .action {
    //            let vc = StoryboardScene.Description.descriptionAndLikesCountViewController.instantiate()
    //            vc.content = actions[indexPath.row].data
    //            navigationController?.present(vc, animated: true, completion: nil)
    //        }
            
        }
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if !viewDidAppearAnimated {
//            let animation = TableViewCellAnimationFactory.slideIn(duration: 0.15, delayFactor: 0.05)
//            let animator = TableViewCellAnimator(animation: animation)
//            animator.animate(cell: cell, at: indexPath, in: tableView)
//            viewDidAppearAnimated = tableView.frame.height <= (CGFloat(indexPath.row + 1) * cell.frame.height)
//        }
//    }
    
}


//MARK:- ManageItTableViewCellDelegate

extension ActionsListViewController: ManageItTableViewCellDelegate {
    
    func tapButton(buttonType: GroupContentButtonPressType, content: ActivityContent) {
        presenter.input(.tappedContentInGroup(pressType: buttonType, content: content))
    }
}


//MARK:- ActionTableViewCellDelegate

extension ActionsListViewController: ActionTableViewCellDelegate {
    
    func tapThreeDotsButton(item: ActionEntity) {
        
        presenter.input(.share)
        
        print("Share")
//        self.shareContent(item: nil)
    }
    
    func tapDownloadButton(cell: ActionTableViewCell) {
        print("download")
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let item = actions[indexPath.row]
        if !item.download {
            item.download = !item.download
            guard let data = item.data else { return }
            presenter.input(.download(data))
        }
        tableView.reloadRows(at: [indexPath], with: .none)
        
    }
    
    func tapLikeButton(cell: ActionTableViewCell) {
        
        presenter.input(.like)
        
        print("like")
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let item = actions[indexPath.row]
        item.like = !item.like
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    func tapAddActionPlanButton(cell: ActionTableViewCell) {
        guard let index = tableView.indexPath(for: cell)?.row else { return }
        guard let content = actions[index].data else {return}
        presenter.input(.addActionPlan(content))
    }
}

//extension ActionsListViewController: ContentToolBarDelegate {
//    func saveContent() {
//        guard let content = selectedContent else { return }
//        DataSource.shared.saveContent(content: content)
//    }
//
//    func removeFromCache() {
//        guard let content = selectedContent else { return }
//        DataSource.shared.deleteContent(content: content)
//    }
//
//    func likeContent(_ isLiked: Bool) {
//        guard let content = selectedContent else { return }
//    }
//
//    func playerStoped(with totalDuration: TimeInterval) {
//        guard let type = selectedContent?.type else { return }
//        let durationInMinutes = Int(totalDuration / 60)
//        boldnessChanged(duration: durationInMinutes)
//        switch type {
//        case .meditation:
//            if durationInMinutes >= 7 {
//                updatePoints()
//            }
//        case .hypnosis:
//            if durationInMinutes >= 20 {
//                updatePoints()
//            }
//        case .preptalk:
//            if totalDuration >= 3 {
//                updatePoints()
//            }
//        case .story:
//            // TODO: - story duration
//            break
//        case .lesson, .quote:
//            break
//        }
//    }
//
//    private func boldnessChanged(duration: Int) {
//        SettingsService.shared.boldness += duration
//    }
//
//    private func updatePoints() {
//        LevelOfMasteryService.shared.input(.addPoints(points: 10))
//    }
//
//    func addActionPlan() {
//        guard let content = selectedContent else { return }
//        presenter.input(.addActionPlan(content))
//    }
//
//}
