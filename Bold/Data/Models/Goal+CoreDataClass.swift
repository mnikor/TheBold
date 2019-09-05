//
//  Goal+CoreDataClass.swift
//  
//
//  Created by Alexander Kovalov on 9/3/19.
//
//

import Foundation
import CoreData


public class Goal: NSManagedObject {

    convenience init() {
        
        let entity = DataSource.shared.entityForName(name: .goal)
        self.init(entity: entity!, insertInto: DataSource.shared.backgroundContext)
    }
    
}
