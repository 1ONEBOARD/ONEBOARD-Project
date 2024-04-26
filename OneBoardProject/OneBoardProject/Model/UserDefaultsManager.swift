//
//  UserDefaultsManager.swift
//  OneBoardProject
//
//  Created by 배지해 on 4/25/24.
//

import Foundation

struct UserDefaultsManager {
    
    static let shared = UserDefaultsManager()
    private init() {}
    
    func setUserDefaults(userID: String, userName: String, autoLoginEnabled: Bool) {
        UserDefaults.standard.set(userID, forKey: UserDefault.userID.rawValue)
        UserDefaults.standard.set(false, forKey: UserDefault.userStatus.rawValue)
        UserDefaults.standard.set(userName, forKey: UserDefault.userName.rawValue)
        UserDefaults.standard.set(autoLoginEnabled, forKey: UserDefault.autoLoginEnabled.rawValue)
    }
    
    func setRentalKickboardData(kickboardId: String, kickboardNumber: Int, rentalStartTime: String) {
        UserDefaults.standard.set(kickboardId, forKey: UserDefault.kickBoardID.rawValue)
        UserDefaults.standard.set(kickboardNumber, forKey: UserDefault.kickBoardNumber.rawValue)
        UserDefaults.standard.set(rentalStartTime, forKey: UserDefault.kickboardStartTime.rawValue)
    }
    
    func setUserDefaults(userStatus: Bool) {
        UserDefaults.standard.set(userStatus, forKey: UserDefault.userStatus.rawValue)
    }
    
    func deleteUserDefaultInfo() {
        if let bundleID = Bundle.main.bundleIdentifier { UserDefaults.standard.removePersistentDomain(forName: bundleID) }
    }
    
    func getUserDefaultsUserID() -> String {
        guard let userID = UserDefaults.standard.string(forKey: UserDefault.userID.rawValue) else { return "" }
        return userID
    }
    
    func getUserDefaultsUserName() -> String {
        guard let userName = UserDefaults.standard.string(forKey: UserDefault.userName.rawValue) else { return "" }
        return userName
    }
    
    func getUserDefaultsUserStatus() -> Bool {
        return UserDefaults.standard.bool(forKey: UserDefault.userStatus.rawValue)
    }
    
    func getUserDefaultsKickboardID() -> String {
        guard let kickboardId = UserDefaults.standard.string(forKey: UserDefault.kickBoardID.rawValue) else { return "" }
        return kickboardId
    }
    
    func getUserDefaultsKickboardNumber() -> Int {
        return UserDefaults.standard.integer(forKey: UserDefault.kickBoardNumber.rawValue)
    }
    
    func getUserDefaultsKickboardStartTime() -> String {
        guard let kickboardStartTime = UserDefaults.standard.string(forKey: UserDefault.kickboardStartTime.rawValue) else { return "" }
        return kickboardStartTime
    }
    
    func calculateKickboardTotalTime() -> Int {
        guard let start = getUserDefaultsKickboardStartTime().toDate() else {
            return 0
        }
        print(start)
        print(Date())
        return Int(round(Date().timeIntervalSince(start) / 60))
    }
    
    func calculateKickboardRentalPrice() -> Int {
        return calculateKickboardTotalTime() * 180
    }
}
