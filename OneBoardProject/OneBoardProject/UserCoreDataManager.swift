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
    
    // PersistentContainer에 접근
    private var persistentContainer: NSPersistentContainer? {
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    }
    
    private var userID: String = ""
    
    func setUserData(userName: String, userID: String, userPassword: String) {
        
        guard let context = self.persistentContainer?.viewContext else { return }
        let userInform = Users(context: context)
        
        userInform.userName = userName
        userInform.userID = userID
        userInform.userPassword = userPassword
        userInform.userStatus = false
        
        try? context.save()
    }
    
    func getUserData() -> [Users]? {
        guard let context = self.persistentContainer?.viewContext else { return [] }
        
        let request = Users.fetchRequest()
        let user = try? context.fetch(request)
        
        return user
    }
    
    mutating func setUserID(userID: String) {
        self.userID = userID
    }
}
