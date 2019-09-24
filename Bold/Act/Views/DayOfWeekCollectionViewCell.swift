//
//  DayOfWeekCollectionViewCell.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/30/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

class DayOfWeekCollectionViewCell: BaseCollectionViewCell {

    @IBOutlet weak var dayButton : UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        dayButton.borderWidth(color: Color(red: 233/255, green: 233/255, blue: 235/255, alpha: 1))
    }

    func config(day: DaysOfWeekType, selectDays:[DaysOfWeekType]) {

        dayButton.setTitle(day.shortText, for: .normal)
        
        let searchDay = selectDays.filter { $0 == day}
        
        if searchDay.isEmpty {
            dayButton.backgroundColor = .white
            dayButton.setTitleColor(.black, for: .normal)
        } else {
            dayButton.backgroundColor = ColorName.primaryBlue.color
            dayButton.setTitleColor(.white, for: .normal)
        }
    }
    
}
