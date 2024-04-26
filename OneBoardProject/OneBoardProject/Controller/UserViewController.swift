//
//  UserViewController.swift
//  OneBoardProject
//
//  Created by 배지해 on 4/22/24.
//

import UIKit

class UserViewController: UIViewController {

    @IBOutlet weak var userTableView: UITableView!
    @IBOutlet weak var logoutButton: UIButton!
    
    var userDefaultsManager = UserDefaultsManager.shared
    var rentalDataManager = RentalDataManager.shared
    var userName: String = ""
    var userID: String = ""
    var userStatus: Bool = false
    var rentalList = [KickboardRental]()
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 유저 정보 설정
        setUserInfo()
        // 로그아웃 버튼 UI 설정
        setLogOutButton()
        // TableView 설정
        setUserTableView()
        // 유저 id에 따른 rentalList 설정
        setKickboardList()
    }
    
    
    // MARK: - 유저 정보 설정
    func setUserInfo() {
        userName = userDefaultsManager.getUserDefaultsUserName()
        userID = userDefaultsManager.getUserDefaultsUserID()
        userStatus = userDefaultsManager.getUserDefaultsUserStatus()
    }
    

    // MARK: - 로그아웃 버튼 UI 설정
    func setLogOutButton() {
        logoutButton.layer.masksToBounds = true
        logoutButton.layer.cornerRadius = 12
    }
    
    
    // MARK: - 로그아웃 버튼
    @IBAction func logOutButtonTapped(_ sender: UIButton) {
        
        print("로그아웃 되었습니다.")
        userDefaultsManager.deleteUserDefaultInfo()
        
        // 로그인 페이지로 이동
        navigateToMainPage()
    }
    
    
    // MARK: - User -> Login 페이지로 이동
    private func navigateToMainPage() {
        
        let targetStoryboard = UIStoryboard(name: "LoginPage", bundle: nil)
        guard let targetVC = targetStoryboard.instantiateViewController(withIdentifier: "LoginPage") as? LoginPageController else {
            print("Failed to instantiate LoginPageController from LoginPage.")
            return
        }
        
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate,
           let window = sceneDelegate.window {
            window.rootViewController = targetVC
            window.makeKeyAndVisible()
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
        }
    }
}
