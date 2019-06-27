//
//  PlayerSmallView.swift
//  Bold
//
//  Created by Alexander Kovalov on 6/24/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

class PlayerSmallView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var actionImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    
    @IBOutlet weak var playButton: UIButton!
    
    @IBAction func tapPlayButton(_ sender: UIButton) {
    }
    @IBAction func tapCloseButton(_ sender: UIButton) {
    }
}
