//
//  String+Extensions.swift
//  Bold
//
//  Created by Alexander Kovalov on 5/29/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation

extension String {
    
    func fileName() -> String {
        return NSURL(fileURLWithPath: self).deletingPathExtension?.lastPathComponent ?? ""
    }
    
    func fileExtension() -> String {
        return NSURL(fileURLWithPath: self).pathExtension ?? ""
    }
}
