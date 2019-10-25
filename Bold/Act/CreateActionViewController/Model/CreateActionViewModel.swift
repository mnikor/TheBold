//
//  CreateActionViewModel.swift
//  Bold
//
//  Created by Alexander Kovalov on 9/9/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation
import UIKit

struct CreateActionViewModel {
    let name : String?
    let startDate : String
    let reminder : String
    let goal : String?
    let stake : String
    let content : SmallContentViewModel?
}

struct SmallContentViewModel {
    let image: UIImage
    let title: String
    let subtitle: String?
    let points: String
    let shapeIcon: UIImage
}
//icon: UIImage, title: String, subtitle: String, points: String
