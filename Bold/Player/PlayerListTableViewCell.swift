//
//  PlayerListTableViewCell.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/3/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

class PlayerListTableViewCell: BaseTableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func config(item : SongEntity) {
        
        nameLabel.text = item.name
        durationLabel.text = item.duration
    }
    
}
