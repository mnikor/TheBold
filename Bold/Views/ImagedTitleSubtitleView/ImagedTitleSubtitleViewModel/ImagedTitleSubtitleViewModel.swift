//
//  ImagedTitleSubtitleViewModel.swift
//  Bold
//
//  Created by Admin on 8/14/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

struct ImagedTitleSubtitleViewModel {
    let leftImagePath: String?
    let imageLoadingCompletion: ((UIImage?) -> Void)?
    let title: String?
    let attributedTitle: NSAttributedString?
    let subtitle: String?
    let attributedSubtitle: NSAttributedString?
    let rightImage: UIImage?
}
