//
//  ConfigurateActionViewController.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/24/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

enum ConfigureActionType {
    case header(HeaderType)
    case body(BodyType)
    
    enum HeaderType {
        case startDate
        case endDate
        case repeatAction
        case remindMe
        case when
        case chooseGoal
        case orCreateNew
        
        func titleText() -> String {
            switch self {
            case .startDate:
                return L10n.Act.Duration.startDate
            case .endDate:
                return L10n.Act.Duration.endDate
            case .repeatAction:
                return L10n.Act.Duration.repeat
            case .remindMe:
                return L10n.Act.Reminders.remindMe
            case .when:
                return L10n.Act.Reminders.when
            case .chooseGoal:
                return L10n.Act.Goals.chooseGoal
            case .orCreateNew:
                return L10n.Act.Goals.orCreateNew
            }
        }
    }
    
    enum BodyType {
        case today
        case tommorow
        case chooseDate
        case afterOneWeek
        case noRepeat
        case everyDay
        case daysOfWeek
        case week
        case noReminders
        case beforeTheDay
        case onTheDay
        case setTime
        case goalName
        case enterGoal
        case none
        
        func titleText() -> String {
            switch self {
            case .today:
                return L10n.Act.Duration.today
            case .tommorow:
                return L10n.Act.Duration.tommorow
            case .chooseDate:
                return L10n.Act.Duration.chooseDate
            case .afterOneWeek:
                return L10n.Act.Duration.afterOneWeek
            case .noRepeat:
                return L10n.Act.Duration.noRepeat
            case .everyDay:
                return L10n.Act.Duration.everyDay
            case .daysOfWeek:
                return L10n.Act.Duration.daysOfWeek
            case .noReminders:
                return L10n.Act.Reminders.noReminders
            case .beforeTheDay:
                return L10n.Act.Reminders.beforeTheDay
            case .onTheDay:
                return L10n.Act.Reminders.onTheDay
            case .setTime:
                return L10n.Act.Reminders.setTime
            case .enterGoal:
                return L10n.Act.Goals.enterYourGoal
            default:
                return String()
            }
        }
        
        func accesoryIsHidden() -> Bool {
            switch self {
            case .chooseDate, .daysOfWeek, .setTime:
                return false
            default:
                return true
            }
        }
        
        func currentValueIsHidden() -> Bool {
            switch self {
            case .today:
                return false
            default:
                return true
            }
        }
    }
}

protocol ConfigurateActionViewControllerDelegate: class {
    func updateData()
}

class ConfigurateActionViewController: UIViewController, ViewProtocol {
    
    typealias Presenter = ConfigurateActionPresenter
    typealias Configurator = ConfigurateActionConfigurator
    
    var presenter: Presenter!
    var configurator: Configurator! = ConfigurateActionConfigurator()

    @IBOutlet weak var tableView: UITableView!
    
    weak var delegate: ConfigurateActionViewControllerDelegate?
    var settingsActionType: AddActionCellType!
    
    var headers = [ConfigureActionModel]()
    var selectDays = [DayWeekType]()
    
    func configure() {
        
        guard let settingsActionType = settingsActionType else { return }
        
        switch settingsActionType {
        case .duration:
            createDuration()
        case .reminder:
            createRemienders()
        case .goal:
            createGoal()
        default:
            return
        }
    }
    
    func createDuration() {
        
        headers = [ConfigureActionModel(headerType: ConfigureActionType.header(.startDate),
                                        bodysType: [ConfigureActionType.body(.today),
                                                    ConfigureActionType.body(.tommorow),
                                                    ConfigureActionType.body(.chooseDate)]),
                   
                   ConfigureActionModel(headerType: ConfigureActionType.header(.endDate),
                                        bodysType: [ConfigureActionType.body(.tommorow),
                                                    ConfigureActionType.body(.afterOneWeek),
                                                    ConfigureActionType.body(.chooseDate)]),
                   
                   ConfigureActionModel(headerType: ConfigureActionType.header(.repeatAction),
                                        bodysType: [ConfigureActionType.body(.noRepeat),
                                                    ConfigureActionType.body(.everyDay),
                                                    ConfigureActionType.body(.daysOfWeek)])
        ]
    }
    
    func createRemienders() {
        
        headers = [ConfigureActionModel(headerType: ConfigureActionType.header(.remindMe),
                                        bodysType: [ConfigureActionType.body(.noReminders),
                                                    ConfigureActionType.body(.beforeTheDay),
                                                    ConfigureActionType.body(.onTheDay)]),
                   
                   ConfigureActionModel(headerType: ConfigureActionType.header(.when),
                                        bodysType: [ConfigureActionType.body(.setTime)])]
    }
    
    func createGoal() {
        
        headers = [
        ConfigureActionModel(headerType: ConfigureActionType.header(.chooseGoal),
                                        bodysType: [ConfigureActionType.body(.goalName)]),
                   
                   ConfigureActionModel(headerType: ConfigureActionType.header(.orCreateNew),
                                        bodysType: [ConfigureActionType.body(.enterGoal)])]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configurator.configure(with: self)
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 40))
        tableView.tableFooterView = footerView
        registerXibs()
        configNavigationController()
        
        configure()
    }
    
    func registerXibs() {
        //tableView.registerNib(HeaderWriteActionsTableViewCell.self)
        //tableView.registerNib(SettingActionPlanTableViewCell.self)
        
        tableView.registerNib(HeaderConfigureTableViewCell.self)
        tableView.registerNib(BodyConfigureTableViewCell.self)
        tableView.registerNib(DaysOfWeekTableViewCell.self)
        tableView.registerNib(EnterYourGoalTableViewCell.self)
    }
    
    func configNavigationController() {
        
        navigationController?.navigationBar.tintColor = .blue
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black]
        navigationItem.title = settingsActionType.textType()
    }

}

//MARK:- UITableViewDelegate, UITableViewDataSource

extension ConfigurateActionViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return headers.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let items = headers[section]
        return items.allElements().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let items = headers[indexPath.section]
        let item = items.allElements()[indexPath.row]
        
        switch item {
        case .header(let headerSection):
            let cell = tableView.dequeReusableCell(indexPath: indexPath) as HeaderConfigureTableViewCell
            cell.config(name: headerSection.titleText())
            return cell
        case .body(let bodyType):
            if bodyType == .enterGoal {
                let cell = tableView.dequeReusableCell(indexPath: indexPath) as EnterYourGoalTableViewCell
                cell.config()
                return cell
            }else if bodyType == .week {
                let cell = tableView.dequeReusableCell(indexPath: indexPath) as DaysOfWeekTableViewCell
                cell.config(selectDays: selectDays)
                cell.delegate = self
                return cell
            }else {
                let cell = tableView.dequeReusableCell(indexPath: indexPath) as BodyConfigureTableViewCell
                cell.config(type: bodyType, model: items)
                return cell
            }
        default:
            return UITableViewCell()
        }
        
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        let items = headers[indexPath.section]
        let item = items.allElements()[indexPath.row]
        
        switch item {
        case .header(_):
            return
        case .body(let bodyType):
            
            if bodyType != .daysOfWeek && items.isSelected == .daysOfWeek {
                items.bodysType.removeLast()
            }else if bodyType == .daysOfWeek && items.isSelected != .daysOfWeek{
                items.bodysType.append(ConfigureActionType.body(.week))
            }
            
            items.isSelected = bodyType
        }
        tableView.reloadData()
    }
    
}

//MARK:- DaysOfWeekTableViewCellDelegate

extension ConfigurateActionViewController: DaysOfWeekTableViewCellDelegate {
    
    func selectDay(selectDays: [DayWeekType]) {
        self.selectDays = selectDays
    }
}

class ConfigureActionModel: NSObject {
    var headerType : ConfigureActionType
    var bodysType : [ConfigureActionType]
    var currentValue: Date
    var isSelected: ConfigureActionType.BodyType
    
    init(headerType: ConfigureActionType, bodysType:[ConfigureActionType] , currentValue: Date = Date(), isSelected: ConfigureActionType.BodyType = .none) {
        self.headerType = headerType
        self.bodysType = bodysType
        self.currentValue = currentValue
        self.isSelected = isSelected
    }
    
    func allElements() -> [ConfigureActionType] {
        return [headerType] + bodysType
    }
}
