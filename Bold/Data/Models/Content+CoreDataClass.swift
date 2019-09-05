//
//  Content+CoreDataClass.swift
//  
//
//  Created by Alexander Kovalov on 9/4/19.
//
//

import Foundation
import CoreData


public class Content: NSManagedObject {

    convenience init() {
        
        let entity = DataSource.shared.entityForName(name: .content)
        self.init(entity: entity!, insertInto: DataSource.shared.backgroundContext)
    }
    
}
