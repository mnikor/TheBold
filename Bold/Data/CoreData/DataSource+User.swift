//
//  DataSource+User.swift
//  Bold
//
//  Created by Alexander Kovalov on 9/3/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation
import CoreData

protocol UserFunctionality {
    func addUser()
    func updateUser()
    func deleteUser()
}

extension DataSource: UserFunctionality {
    func addUser() {
        
    }
    
    func updateUser() {
        
    }
    
    func deleteUser() {
        
    }
    
    func readUser() -> User {
        
        var result : User!
        let fetchRequest = NSFetchRequest<User>(entityName: "User")
        
        do {
            result = try DataSource.shared.backgroundContext.fetch(fetchRequest).first
        } catch {
            print(error)
        }
        
        if result == nil {
            return createNewUser()
        }
        
        return result
    }
    
    func createNewUser() -> User {
        
        let user = User()
        user.calendarOn = false
        user.downloadOnlyWifiOn = false
        user.iCloudOn = false
        user.levelOfMasteryPoints = 0
        user.token = nil
        user.firstOpenIdeas = true
        
        DataSource.shared.saveBackgroundContext()
        return user
    }
}
