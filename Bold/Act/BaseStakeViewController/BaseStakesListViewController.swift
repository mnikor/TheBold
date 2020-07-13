//
//  BaseStakesListViewController.swift
//  Bold
//
//  Created by Alexander Kovalov on 19.11.2019.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit
import PassKit

class BaseStakesListViewController: UIViewController, ViewProtocol {
    
    @IBOutlet weak var tableView: UITableView!
    
    typealias Presenter = BaseStakesListPresenter
    typealias Configurator = BaseStakesListConfigurator
    
    var presenter: Presenter!
    var configurator: Configurator! = BaseStakesListConfigurator()
    
    var user = DataSource.shared.readUser()
    
    var infoView: UIView!
    
    var isShown = false
    var topCellIndexPath: IndexPath?
    var cellContentView: UIView?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupConfiguration()
    }
    
    convenience init() {
        self.init()
        setupConfiguration()
    }
    
    func setupConfiguration() {
        configurator.configure(with: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.input(.createDataSource(goalID: presenter.goal?.id))
        presenter.input(.subscribeToUpdate)
        
        configTableView()
        configNavigationController()
        registerXibs()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if let indxPath = topCellIndexPath {
            setupInfoView(indxPath)
            topCellIndexPath = nil
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let textAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor(red: 82/255, green: 109/255, blue: 209/255, alpha: 1)]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
    
    func configTableView() {
        tableView.backgroundView = presenter.dataSource.isEmpty ? EmptyActView.loadFromNib() : UIView()
        tableView.tableFooterView = UIView()
        tableView.estimatedSectionHeaderHeight = UITableView.automaticDimension
        tableView.sectionHeaderHeight = 84
    }
    
    private func configNavigationController() {
        self.navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.tintColor = ColorName.primaryBlue.color
        navigationController?.navigationBar.barTintColor = .white
        navigationItem.title = presenter.goal?.name ?? L10n.viewAll
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: Asset.plusTodayActions.image, style: .plain, target: self, action: #selector(tapCreateAction))
        
        let backItem = UIBarButtonItem(image: UIImage(named: "arrowBack"), style: .plain, target: self, action: #selector(tapBackButton))
        navigationItem.leftBarButtonItem = backItem
    }
    
    private func setupInfoView(_ indexPath: IndexPath) {
        
        if user.stakeInfo { return }
        
        let rectOfCell = tableView.rectForRow(at: indexPath)
        let rectOfCellInSuperview = tableView.convert(rectOfCell, to: tableView.superview)
        
        let frame = CGRect(x: rectOfCellInSuperview.origin.x,
                           y: rectOfCellInSuperview.origin.y,
                           width: rectOfCellInSuperview.size.width,
                           height: rectOfCellInSuperview.size.height)
        
        infoView = UIView(frame: frame)
        
        setupCellContentView(with: frame, to: infoView)
        
        view.addSubview(infoView)
        
        
        InfoService.showInfo(type: .stakeCell, baseView: infoView) {
            self.infoView.isHidden = true
            self.user.stakeInfo = true
            DataSource.shared.saveBackgroundContext()
            NotificationService.shared.requestAuthorizaton()
        }
        
    }
    
    private func setupCellContentView(with frame: CGRect, to infoView: UIView) {
        
        cellContentView?.frame = CGRect(x: frame.origin.x,
                                        y: frame.origin.y,
                                        width: frame.size.width,
                                        height: frame.size.height)
        cellContentView?.backgroundColor = .white
        cellContentView?.translatesAutoresizingMaskIntoConstraints = false
        cellContentView?.layer.cornerRadius = 10
        
        infoView.addSubview(cellContentView!)
        
        NSLayoutConstraint.activate([
        
            cellContentView!.topAnchor.constraint(equalTo: infoView.topAnchor),
            cellContentView!.leadingAnchor.constraint(equalTo: infoView.leadingAnchor, constant: 20),
            cellContentView!.trailingAnchor.constraint(equalTo: infoView.trailingAnchor, constant: -20),
            cellContentView!.bottomAnchor.constraint(equalTo: infoView.bottomAnchor)
        
        ])
    }
    
    @objc private func tapBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func tapCreateAction() {
        presenter.input(.createAction)
    }
    
    private func registerXibs() {
        tableView.registerNib(NavigationTitleAndProgressTableViewCell.self)
        tableView.registerNib(ActivityCollectionTableViewCell.self)
        tableView.registerNib(StakeActionTableViewCell.self)
        tableView.registerNib(CalendarTableViewCell.self)
        tableView.registerHeaderFooterNib(StakeHeaderView.self)
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        if let vc = segue.destination as? CreateActionViewController {
    //            //vc.delegate = self
    //            //guard let settingType = sender as? AddActionCellType else {return}
    //            //vc.settingsActionType = settingType
    //            vc.presenter.goal = presenter.goal
    //        }
    //    }
    
//MARK:- InfoFunctions
    
    func checkNeedInfo() {
        self.tableView.layoutIfNeeded() // Stops cutting the infoView but it still on top
        
        if case .archive = presenter.type {
            return
        }
        
        if let infoVC = UIApplication.shared.keyWindow?.rootViewController?.children.last, ((infoVC as? InfoService) != nil) {
            return
        }
        
        let user = DataSource.shared.readUser()
        
//        user.goalInfo = false
//        user.stakeInfo = false
//        user.stakeContentInfo = false
//        DataSource.shared.saveBackgroundContext()
//        return
        
        if user.stakeInfo && user.stakeContentInfo && user.goalInfo {
            return
        }
        
        let vesibleCells = checkVisibilityOf()
        
        for cell in vesibleCells {
            
            if !user.goalInfo, let activityCell = cell as? ActivityCollectionTableViewCell {
                
                let indexPaths = activityCell.collectionView.indexPathsForVisibleItems.sorted()
                if indexPaths.isEmpty {
                    break
                }
                
                if indexPaths.count > 1 {
                    
                    if let goalCell = activityCell.collectionView.cellForItem(at: indexPaths[1]) as? GoalCollectionViewCell {
                        
                        InfoService.showInfo(type: .goalCell, baseView: goalCell.goalView) { [unowned self] in
                            user.goalInfo = true
                            DataSource.shared.saveBackgroundContext()
                            self.checkNeedInfo()
                        }
                    }
                }
                break
            }
            
            if let stakeCell = cell as? StakeActionTableViewCell {
                
                let indexPath = tableView.indexPath(for: stakeCell)!
                let section = presenter.dataSource[indexPath.section]
                
                let item = section.items[indexPath.row]

                if case .event(viewModel: let cellModel) = item {

                    if !user.stakeContentInfo, let _ = cellModel.event.action?.content {

                        InfoService.showInfo(type: .stakeContentCell, baseView: stakeCell.contentActionView) { [unowned self] in
                            user.stakeContentInfo = true
                            DataSource.shared.saveBackgroundContext()
                            self.checkNeedInfo()
                        }
                        break
                    } else if !user.stakeInfo {
//                        InfoService.showInfo(type: .stakeCell, baseView: stakeCell.contentActionView) { [unowned self] in
//                            user.stakeInfo = true
//                            DataSource.shared.saveBackgroundContext()
//                            self.checkNeedInfo()
//                        }
                        break
                    }
                }
            }
        }
    }
    
    func checkVisibilityOf() -> [UITableViewCell] { //(in aScrollView: UIScrollView?) {
        
        let cells = tableView.visibleCells
        
        if cells.isEmpty {
            return []
        }
        
        let filterCell = cells.filter { (cell) -> Bool in
            
            let indexPath = tableView.indexPath(for: cell)
            let cellRect = tableView.rectForRow(at: indexPath!)
            
            if tableView.bounds.contains(cellRect) {
                return true
            }else {
                return false
            }
        }
        return filterCell
    }
    
    func showApplePayController(paymentRequest: PKPaymentRequest) {
        
        if PKPaymentAuthorizationController.canMakePayments() {
            
            if let controller = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest) {
                controller.delegate = self
                
                DispatchQueue.main.async {[weak self] in
                    guard let ss = self else { return }
                    ss.present(controller, animated: true, completion: nil)
                }
            }
            
        } else { print("User can't make payments") }
    }
    
}


//MARK:- UIScrollViewDelegate

extension BaseStakesListViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        checkNeedInfo()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        checkNeedInfo()
    }
}


//MARK:- UITableViewDelegate, UITableViewDataSource

extension BaseStakesListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionItem = presenter.dataSource[section]
        
        switch sectionItem.section {
        case .calendar:
            return sectionItem.items.count
        default:
            return sectionItem.items.count + 1
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: StakeHeaderView.reuseIdentifier) as! StakeHeaderView
        let section = presenter.dataSource[section]

        switch section.section {
        case .goal:
            return nil
        case .calendar(viewModel: let sectionModel):
            headerView.config(viewModel: sectionModel)
        case .stake(viewModel: let sectionModel):
            headerView.config(viewModel: sectionModel)
        }

        headerView.delegate = self
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            let headerModel = presenter.dataSource[section].section
            switch headerModel {
            case .goal:
                return 0
            default:
                return 84
            }
        }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let headerCell = cell as? NavigationTitleAndProgressTableViewCell {
            if !headerCell.progressView.changePointView.isHidden {
                animateChangePoint(cell: headerCell)
            }
            
            LevelOfMasteryService.shared.input(.currentLevel(level: {(level) in
                
                let currentPoints = Double(LevelOfMasteryService.shared.currentPoints())
                
                let currentLevelLimit = Double(level.limits.getAllLimits().points)
                
                if currentPoints <= currentLevelLimit {
                    headerCell.progressView.progressView.progress = Float(currentPoints) / Float(LevelOfMasteryService.shared.closedLevels.compactMap({ $0.limits.getAllLimits().points }).sorted().first(where: { Double($0) > currentPoints }) ?? 1)
                } else {
                    headerCell.progressView.progressView.progress = 1
                }
                
            }))
        }
        presenter.input(.uploadNewEventsInDataSourceWhenScroll(indexPath.section))
    }
    
    @objc func animateChangePoint(cell: NavigationTitleAndProgressTableViewCell) {
        UIView.animate(withDuration: 2, animations: {
            cell.progressView.changePointView.alpha = 0
        }) { (_) in
            cell.progressView.changePointView.isHidden = true
            cell.progressView.changePointView.alpha = 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var isCalendar = false
        
        let sectionItem = presenter.dataSource[indexPath.section]
        
        switch sectionItem.section {
        case .calendar:
            isCalendar = true
        default:
            isCalendar = false
        }
        
        if indexPath == IndexPath(row: 0, section: 0) && !isCalendar {

            let headerCell = tableView.dequeReusableCell(indexPath: indexPath) as NavigationTitleAndProgressTableViewCell
            return headerCell

        } else {
            
            let section = presenter.dataSource[indexPath.section]
            
            var item: CalendarModelType
            
            if indexPath.section == 0 && !isCalendar { item = section.items[indexPath.row - 1]}
            else { item = section.items[indexPath.row] }
            
            switch item {
            case .calendar(dates: _):
                let cell = tableView.dequeReusableCell(indexPath: indexPath) as CalendarTableViewCell
                cell.config(date: presenter.currentDate, startDate:presenter.goal?.startDate as Date?, endDate:presenter.goal?.endDate as Date?, modelView: item)
                cell.delegate = self
                return cell
            case .event(viewModel: _):
                let cell = tableView.dequeReusableCell(indexPath: indexPath) as StakeActionTableViewCell
                cell.config(viewModel: item)
                cell.delegate = self
                
                // Check if we need to show orange info view
                
                if !isShown && !user.stakeInfo {
                    topCellIndexPath = indexPath
                    cellContentView = cell.contentActionView.copyView()
                    isShown = true
                }
                
                return cell
            case .goals(viewModel: _):
                let cell = tableView.dequeReusableCell(indexPath: indexPath) as ActivityCollectionTableViewCell
                
                if case .goals(viewModel: let activityViewModel) = item {
                    cell.configCell(viewModel: activityViewModel)
                }
                
                cell.delegate = self
                cell.backgroundColor = UIColor(red: 244/255, green: 245/255, blue: 249/255, alpha: 1)
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        let section = presenter.dataSource[indexPath.section]
        
        if case .calendar(viewModel: let model) = section.section {
            switch model.type {
            case .goal:
                return
            default:
                presenter.input(.selectEvent(indexPath: indexPath))
            }
        }
    }
}


//MARK:- StakeHeaderViewDelegate

extension BaseStakesListViewController: StakeHeaderViewDelegate {

    func tapRightButton(type: ActHeaderType) {
        presenter.input(.calendarHeader(type))
    }
}


//MARK:- StakeActionTableViewCellDelegate

extension BaseStakesListViewController: StakeActionTableViewCellDelegate {
    
    func tapLongPress(event: Event) {
        presenter.input(.longTapAction(event: event))
    }
}


//MARK:- CalendarTableViewCellDelegate

extension BaseStakesListViewController: CalendarTableViewCellDelegate {
    
    func currentMonthInCalendar(date: Date) {
        print("CURRENT calendar month from = \(date)")
        presenter.input(.scrollToMonthInCalendar(date))
    }
    
    func tapMonthTitle(date: Date) {
        presenter.input(.yearMonthAlert(date: date))
    }
    
    func selectDate(date: Date) {
        print("\(date)")
        presenter.currentDate = date
        presenter.input(.selectCalendarSection(date: date))
        
    }
}

// MARK:- ActivityCollectionTableViewCellDelegate

extension BaseStakesListViewController: ActivityCollectionTableViewCellDelegate {
    func tapShowAllActivity(type: HomeActionsTypeCell?) {
        print("tapShowAllActivity")
        presenter.router.input(.allGoals)
    }

    func activityCollectionTableViewCell(_ activityCollectionTableViewCell: ActivityCollectionTableViewCell, didTapAtItem indexPath: IndexPath) {
        print("tapItemCollection")
        //presenter.input(.goalItem)
    }
    
    func tapItemCollection(goal: Goal) {
        print("tapItemCollection")
        presenter.input(.goalItem(goal: goal))
    }
    
    func tapEmptyGoalsCell(type: ActivityViewModel?) {
        presenter.input(.createGoal)
    }
    
    func longTap(goal: Goal) {
        print("long Tap Goal = \(goal.id)")
        presenter.input(.longTapGoal(goal: goal))
    }
    
    func tapCreateGoal() {
        print("createGoal")
    }
}

// MARK: - PKPaymentAuthorizationViewControllerDelegate

extension BaseStakesListViewController: PKPaymentAuthorizationViewControllerDelegate {
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {

        /// 1. Check payment
        /// 2. Send payment token to backend
        /// 3. When we got result call completion ether successfull or failure
        
        print("Payment: \(payment.description) successed!")

        completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
    }
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        /// Show thanks for payment screen at the end if payment was succesfull
        controller.dismiss(animated: true) { [weak self] in
            self?.showSuccessfullScreen()
        }
    }
    
    private func showSuccessfullScreen() {
        let vc = StoryboardScene.Settings.thanksForPaymentViewController.instantiate()
        present(vc, animated: true, completion: nil)
    }
    
}


//extension BaseStakesListViewController: ContentToolBarDelegate {
//    func saveContent() {
//        guard let content = presenter.selectedContent else { return }
//        DataSource.shared.saveContent(content: content)
//    }
//    
//    func removeFromCache() {
//        guard let content = presenter.selectedContent else { return }
//        DataSource.shared.deleteContent(content: content)
//    }
//    
//    func likeContent(_ isLiked: Bool) {
//        guard let _ = presenter.selectedContent else { return }
//    }
//    
//    func playerStoped(with totalDuration: TimeInterval) {
//        guard let type = presenter.selectedContent?.type else { return }
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
//        guard let content = presenter.selectedContent else { return }
//        //presenter.input(.addActionPlan(content))
//    }
//    
//}
