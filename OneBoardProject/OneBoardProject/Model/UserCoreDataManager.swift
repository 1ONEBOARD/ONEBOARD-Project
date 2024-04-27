//
//  UserCoreDataManager.swift
//  OneBoardProject
//
//  Created by 배지해 on 4/25/24.
//

import Foundation
import CoreData
import UIKit

struct UserCoreDataManager {
    
    static let shared = UserCoreDataManager()
    private init() {}
    
    private var persistentContainer: NSPersistentContainer? {
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    }
    
    func setUserData(userName: String, userID: String, userPassword: String) {
        
        guard let context = self.persistentContainer?.viewContext else { return }
        let userInform = Users(context: context)
        
        userInform.userName = userName
        userInform.userID = userID
        userInform.userPassword = userPassword
        
        try? context.save()
    }
    
    func getUserData() -> [Users]? {
        guard let context = self.persistentContainer?.viewContext else { return [] }
        
        let request = Users.fetchRequest()
        let user = try? context.fetch(request)
        
        return user
    }
    
    func getUserNameData(userID: String) -> String {
        guard let context = self.persistentContainer?.viewContext else { return "" }
        
        let request = Users.fetchRequest()
        request.predicate = NSPredicate(format: "userID == %@", userID)
        
        let results = try? context.fetch(request)
        guard let results = results, let userName = results[0].userName else { return "" }
        
        return userName
    }
}
