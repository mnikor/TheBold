//
//  DaysOfWeekTableViewCell.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/30/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

enum DayWeekType {
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    case sunday
    
    var shortText : String {
        switch self {
        case .monday:
            return L10n.Act.Duration.Day.mo
        case .tuesday:
            return L10n.Act.Duration.Day.tu
        case .wednesday:
            return L10n.Act.Duration.Day.we
        case .thursday:
            return L10n.Act.Duration.Day.th
        case .friday:
            return L10n.Act.Duration.Day.fr
        case .saturday:
            return L10n.Act.Duration.Day.sa
        case .sunday:
            return L10n.Act.Duration.Day.su
        }
    }
    
    var weekdayIndex: Int? {
        let weekdaySymbol: String
        switch self {
        case .monday:
            weekdaySymbol = "Monday"
        case .tuesday:
            weekdaySymbol = "Tuesday"
        case .wednesday:
            weekdaySymbol = "Wednesday"
        case .thursday:
            weekdaySymbol = "Thursday"
        case .friday:
            weekdaySymbol = "Friday"
        case .saturday:
            weekdaySymbol = "Saturday"
        case .sunday:
            weekdaySymbol = "Sunday"
        }
        return Calendar.autoupdatingCurrent.weekdaySymbols.firstIndex(of: weekdaySymbol)
    }
    
}

protocol DaysOfWeekTableViewCellDelegate: class {
    func selectDay(selectDays: [DayWeekType])
}

private struct Constants {
    struct CellSize {
        static let size : CGSize = CGSize(width: 42, height: 44)
    }
    struct Insets {
        static let leftIndentCell : CGFloat = 20
        static let rightIndentCell : CGFloat = 16
    }
    struct Spacing {
        static let betweenHorizCell : CGFloat = 8
    }
}

class DaysOfWeekTableViewCell: BaseTableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
    weak var delegate: DaysOfWeekTableViewCellDelegate?
    
    lazy var days: [DayWeekType] = {
        return [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]
    }()
    
    var selectDays = [DayWeekType]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        collectionView.delegate = self
        collectionView.dataSource = self
        registerXibs()
    }
    
    func registerXibs() {
        collectionView.registerNib(DayOfWeekCollectionViewCell.self)
    }
    
    func config(selectDays: [DayWeekType]) {
        
        self.selectDays = selectDays
        collectionView.reloadData()
    }
}

//MARK:- UICollectionViewDelegate, UICollectionViewDataSource

extension DaysOfWeekTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return days.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeReusableCell(indexPath: indexPath) as DayOfWeekCollectionViewCell
        cell.config(day: days[indexPath.row], selectDays: selectDays)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.deselectItem(at: indexPath, animated: false)
        
        //let cell = collectionView.cellForItem(at: indexPath)
        
        let day = days[indexPath.row]
        let searchDay = selectDays.filter { $0 == day}
        
        if searchDay.isEmpty {
            selectDays.append(day)
        }else {
            guard let index = selectDays.firstIndex(of: day) else {
                return
            }
            selectDays.remove(at: index)
        }
        delegate?.selectDay(selectDays: selectDays)
        collectionView.reloadData()
    }
}

//MARK:- UICollectionViewDelegateFlowLayout
extension DaysOfWeekTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let insetsWidth = Constants.Insets.leftIndentCell + Constants.Insets.rightIndentCell
        let widthSpaceAll = collectionView.bounds.size.width - insetsWidth - Constants.Spacing.betweenHorizCell * CGFloat(days.count - 1)
        let widthCellSize = widthSpaceAll / CGFloat(days.count)
        return CGSize(width: widthCellSize, height: Constants.CellSize.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0,
                            left: Constants.Insets.leftIndentCell,
                            bottom: 0,
                            right: Constants.Insets.rightIndentCell)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.Spacing.betweenHorizCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return collectionView.bounds.size.height
    }
    
}
