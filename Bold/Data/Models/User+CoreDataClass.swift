//
//  User+CoreDataClass.swift
//  
//
//  Created by Alexander Kovalov on 9/3/19.
//
//

import Foundation
import CoreData


public class User: NSManagedObject {

    convenience init() {
        
        let entity = DataSource.shared.entityForName(name: .user)
        self.init(entity: entity!, insertInto: DataSource.shared.backgroundContext)
    }
    
}
