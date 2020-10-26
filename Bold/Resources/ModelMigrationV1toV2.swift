//
//  ModelMigrationV1toV2.swift
//  Bold
//
//  Created by Alexander Kovalov on 23.10.2020.
//  Copyright © 2020 Alexander Kovalov. All rights reserved.
//

import Foundation
import CoreData

class ModelMigrationV1toV2 : NSEntityMigrationPolicy {
    
    @objc func typeFor(isAudio: NSNumber) -> NSNumber {
        
        if isAudio.boolValue {
            return NSNumber(integerLiteral: Int(FileType.mp3.rawValue))
        }else {
            return NSNumber(integerLiteral: Int(FileType.pdf.rawValue))
        }
    }
    
}
