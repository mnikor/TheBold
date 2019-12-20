//
//  Event+CoreDataClass.swift
//  
//
//  Created by Alexander Kovalov on 9/16/19.
//
//

import Foundation
import CoreData

@objc(Event)
public class Event: NSManagedObject {

    var calculatePoints: Int {
        return (Int(self.stake) + 5)
    }
    
    convenience init() {
        
        let entity = DataSource.shared.entityForName(name: .event)
        self.init(entity: entity!, insertInto: DataSource.shared.backgroundContext)
    }
    
}
