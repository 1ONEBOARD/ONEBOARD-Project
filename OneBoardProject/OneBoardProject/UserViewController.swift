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
    
    var userData: User = User(userName: "홍길동", 
                              id: "gildong2",
                              password: "1234",
                              status: true,
                              rentalList: [Rental(kickBoardID: "ONE-A1", kickBoardNumber: 123456, rentalStartTime: "2024.01.19 12:40 AM", rentalTotalTime: 7, rentalPrice: 7*180),
                                           Rental(kickBoardID: "ONE-A2", kickBoardNumber: 445678, rentalStartTime: "2024.01.20 12:40 AM", rentalTotalTime: 10, rentalPrice: 10*180),
                                           Rental(kickBoardID: "ONE-B1", kickBoardNumber: 123546, rentalStartTime: "2024.01.23 12:40 AM", rentalTotalTime: 12, rentalPrice: 12*180),
                                           Rental(kickBoardID: "ONE-B2", kickBoardNumber: 879678, rentalStartTime: "2024.01.25 12:40 AM", rentalTotalTime: 11, rentalPrice: 11*180),
                                           Rental(kickBoardID: "ONE-B3", kickBoardNumber: 123453, rentalStartTime: "2024.01.26 12:40 AM", rentalTotalTime: 6, rentalPrice: 6*180),
                                           Rental(kickBoardID: "ONE-A1", kickBoardNumber: 123456, rentalStartTime: "2024.01.19 12:40 AM", rentalTotalTime: 7, rentalPrice: 7*180),
                                           Rental(kickBoardID: "ONE-A2", kickBoardNumber: 445678, rentalStartTime: "2024.01.20 12:40 AM", rentalTotalTime: 10, rentalPrice: 10*180),
                                           Rental(kickBoardID: "ONE-B1", kickBoardNumber: 123546, rentalStartTime: "2024.01.23 12:40 AM", rentalTotalTime: 12, rentalPrice: 12*180),
                                           Rental(kickBoardID: "ONE-B2", kickBoardNumber: 879678, rentalStartTime: "2024.01.25 12:40 AM", rentalTotalTime: 11, rentalPrice: 11*180),
                                           Rental(kickBoardID: "ONE-B3", kickBoardNumber: 123453, rentalStartTime: "2024.01.26 12:40 AM", rentalTotalTime: 6, rentalPrice: 6*180)])

    
//    var userData: User = User(userName: "홍길동",
//                              id: "gildong2",
//                              password: "1234",
//                              status: false,
//                              rentalList: [])
    
    var currentRental: Rental = Rental(kickBoardID: "ONE-A1", kickBoardNumber: 123456, rentalStartTime: "2024.01.19 12:40 AM", rentalTotalTime: 7, rentalPrice: 7*180)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setLogOutButton()
        setUserTableView()
    }
    
    func setLogOutButton() {
        logoutButton.layer.masksToBounds = true
        logoutButton.layer.cornerRadius = 12
    }
    
    @IBAction func logOutButtonTapped(_ sender: UIButton) {
        print("로그아웃 되었습니다.")
        
        UserDefaults.standard.removeObject(forKey: "lastLoggedInUser")
        
        // 로그인 페이지로 이동
        navigateToMainPage()
    }
    
    private func navigateToMainPage() {
        let targetStoryboard = UIStoryboard(name: "LoginPage", bundle: nil)
        guard let targetVC = targetStoryboard.instantiateViewController(withIdentifier: "LoginPage") as? LoginPageController else {
            print("Failed to instantiate LoginPageController from LoginPage.")
            return
        }
        
        targetVC.modalPresentationStyle = .fullScreen
        present(targetVC, animated: true, completion: nil)
    }
}
