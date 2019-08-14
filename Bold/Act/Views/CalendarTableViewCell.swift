//
//  CalendarTableViewCell.swift
//  Bold
//
//  Created by Alexander Kovalov on 8/2/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit
import JTAppleCalendar

protocol CalendarTableViewCellDelegate: class {
    func selectDate(date: Date)
    func tapMonthTitle(date: Date)
}

private struct Constants {
    struct SectionInset {
        static let top: CGFloat = 0
        static let left: CGFloat = 40
        static let bottom: CGFloat = 20
        static let right: CGFloat = 40
    }
    
    struct decorationPadding {
        static let leftRight: CGFloat = 20
    }
    
    struct Header {
        static let height: CGFloat = 130
    }
    
    struct DateFormat {
        static let format = "yyyy MM dd"
    }
}

class CalendarTableViewCell: BaseTableViewCell {

    @IBOutlet weak var calendarView: JTACMonthView!
    
    private let formatter = DateFormatter()
    private var startDate: Date!
    private var endDate: Date!
    
    var currentDate: Date!
    
    weak var delegate: CalendarTableViewCellDelegate?
    
    var scheduleGroup : [String: [Date]]? {
        didSet {
            calendarView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        calendarView.ibCalendarDelegate = self
        calendarView.ibCalendarDataSource = self
        
        calendarView.scrollDirection = .horizontal
        calendarView.scrollingMode   = .stopAtEachCalendarFrame
        calendarView.showsHorizontalScrollIndicator = false
        calendarView.sectionInset = UIEdgeInsets(top: Constants.SectionInset.top, left: Constants.SectionInset.left, bottom: Constants.SectionInset.bottom, right: Constants.SectionInset.right)
        
        registerXibs()
    }
    
    private func registerXibs(){
        calendarView.register(UINib(nibName: DateCalendarCell.Identifier(), bundle: nil), forCellWithReuseIdentifier: DateCalendarCell.Identifier())
        calendarView.register(UINib(nibName: HeaderCalendarView.Identifier(), bundle: nil), forSupplementaryViewOfKind: "Header", withReuseIdentifier: HeaderCalendarView.Identifier())
        calendarView.register(viewClass: CalendarDecorationView.self, forDecorationViewOfKind: CalendarDecorationView.Identifier())
    }
    
    func config(date: Date) {
        self.currentDate = date
        calendarView.selectDates([date])
        calendarView.scrollToHeaderForDate(date)
        scheduleGroup = ["2019 01 10" : [Date()], "2019 01 15" : [Date()]]
    }
    
    func configureCell(view: JTACDayCell?, cellState: CellState) {
        guard let cell = view as? DateCalendarCell  else { return }
        cell.dateLabel.text = cellState.text
        handleCellTextColor(cell: cell, cellState: cellState)
    }
    
    func handleCellTextColor(cell: DateCalendarCell, cellState: CellState) {
        
        if cellState.dateBelongsTo == .thisMonth {
            cell.dateLabel.textColor = ColorName.calendarThisMonth.color
            cell.isUserInteractionEnabled = true
        } else {
            cell.dateLabel.textColor = ColorName.typographyBlack50.color
            cell.isUserInteractionEnabled = false
        }
        
        handleCellSelection(cell: cell, cellState: cellState)
    }
    
    func handleCellSelection(cell: DateCalendarCell, cellState: CellState) {
        if cellState.isSelected {
            cell.dateLabel.textColor = .white
        }
        
        cell.selectView.backgroundColor = cellState.isSelected ? ColorName.primaryOrange.color : .clear
        cell.dotView.backgroundColor = cellState.isSelected ? .white : ColorName.primaryOrange.color
        
        if cellState.dateBelongsTo != .thisMonth {
            cell.selectView.backgroundColor = cellState.isSelected ? ColorName.typographyBlack50.color : .clear
        }
        
        formatter.dateFormat = Constants.DateFormat.format
        if scheduleGroup?[formatter.string(from: cellState.date)] != nil {
            cell.dotView.isHidden = false
        }
        else {
            cell.dotView.isHidden = true
        }
    }
}

//MARK:- JTACMonthViewDataSource

extension CalendarTableViewCell: JTACMonthViewDataSource {
    func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {
        
        formatter.dateFormat = Constants.DateFormat.format
        startDate = formatter.date(from: "2001 01 01")!
        endDate = formatter.date(from: "2031 01 01")!
        
        return ConfigurationParameters(startDate: startDate,
                                       endDate: endDate,
                                       numberOfRows: 6,
                                       calendar: Calendar.current,
                                       generateInDates: .forAllMonths,
                                       generateOutDates: .tillEndOfGrid,
                                       firstDayOfWeek: .monday,
                                       hasStrictBoundaries: true)
    }
    
    func calendar(_ calendar: JTACMonthView, didSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        print("selectDate = \(date)")
        delegate?.selectDate(date: date)
        configureCell(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTACMonthView, didDeselectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        configureCell(view: cell, cellState: cellState)
    }
    
    func sizeOfDecorationView(indexPath: IndexPath) -> CGRect {
        let widthCalendar = calendarView.bounds.size.width
        let x = Constants.decorationPadding.leftRight + CGFloat(indexPath.section) * widthCalendar
        let width = widthCalendar - (Constants.decorationPadding.leftRight * 2)
        return CGRect(x: x, y: 0, width: width, height: calendarView.bounds.size.height)
    }
}

//MARK:- JTACMonthViewDelegate

extension CalendarTableViewCell: JTACMonthViewDelegate {
    
    func calendar(_ calendar: JTACMonthView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTACDayCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: DateCalendarCell.Identifier(), for: indexPath) as! DateCalendarCell
        self.calendar(calendar, willDisplay: cell, forItemAt: date, cellState: cellState, indexPath: indexPath)
        return cell
    }
    
    func calendar(_ calendar: JTACMonthView, willDisplay cell: JTACDayCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        configureCell(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTACMonthView, headerViewForDateRange range: (start: Date, end: Date), at indexPath: IndexPath) -> JTACMonthReusableView {
        let header = calendar.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: HeaderCalendarView.Identifier(), for: indexPath) as! HeaderCalendarView
        header.config(date: range.start, formatter: formatter)
        header.delegate = self
        return header
    }
    
    func calendarSizeForMonths(_ calendar: JTACMonthView?) -> MonthSize? {
        return MonthSize(defaultSize: Constants.Header.height)
    }
    
}

//MARK:- HeaderCalendarViewDelegate

extension CalendarTableViewCell: HeaderCalendarViewDelegate {
    
    func tapMonthTitleButton(date: Date) {
        print("tapMonthTitleButton = \(date)")
        delegate?.tapMonthTitle(date: date)
    }

}
