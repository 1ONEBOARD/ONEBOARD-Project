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
                                           Rental(kickBoardID: "ONE-B3", kickBoardNumber: 123453, rentalStartTime: "2024.01.26 12:40 AM", rentalTotalTime: 6, rentalPrice: 6*180)])
    
    var currentRental: Rental = Rental(kickBoardID: "ONE-A1", kickBoardNumber: 123456, rentalStartTime: "2024.01.19 12:40 AM", rentalTotalTime: 7, rentalPrice: 7*180)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUserTableView()
    }
    
    @IBAction func logOutButtonTapped(_ sender: UIButton) {
        print("logOut되었습니다.")
        // 로그인 페이지로 이동
    }
}

extension UserViewController: UITableViewDelegate, UITableViewDataSource {
    
    func setUserTableView() {
        userTableView.delegate = self
        userTableView.dataSource = self
        
        let nib1 = UINib(nibName: "UserDefaultTableViewCell", bundle: nil)
        let nib2 = UINib(nibName: "RentalListTableViewCell", bundle: nil)
        userTableView.register(nib1, forCellReuseIdentifier: "userDefaultCell")
        userTableView.register(nib2, forCellReuseIdentifier: "rentalListCell")
    }
    
    
    // MARK: - 테이블 뷰의 Section 수 결정
    func numberOfSections(in tableView: UITableView) -> Int {
        
        // 대여중이면 section 수 3개 / 대여중이 아니라면 section 수 2개
        if userData.status {
            return 3
        }else {
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView,
                   titleForHeaderInSection section: Int) -> String? {
        
        // 대여중이면 section 수 3개 / 대여중이 아니라면 section 수 2개
        if userData.status {
            switch section {
            case 0: "프로필"
            case 1: "대여중"
            case 2: "이전 대여 목록"
            default: ""
            }
        }else {
            switch section {
            case 0: "프로필"
            case 1: "이전 대여 목록"
            default: ""
            }
        }
    }
    
    // MARK: - tableView의 셀의 개수
    func tableView(_ tableView: UITableView, 
                   numberOfRowsInSection section: Int) -> Int {
        
        // 대여중이면 section 수 3개 / 대여중이 아니라면 section 수 2개
        if userData.status {
            switch section {
            case 0: 2
            case 1: 1
            case 2: userData.rentalList.count
            default: 0
            }
        }else {
            switch section {
            case 0: 2
            case 1: userData.rentalList.count
            default: 0
            }
        }
    }
    
    func setUserDefaultCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userDefaultCell", for: indexPath) as! UserDefaultTableViewCell
        let cellConfigure: [(String,String)] = [("이름", userData.userName), ("아이디", userData.id)]
        cell.firstLabel.text = cellConfigure[indexPath.row].0
        cell.LastLabel.text = cellConfigure[indexPath.row].1
        return cell
    }
    
    func setUserRentalListCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "rentalListCell", for: indexPath) as! RentalListTableViewCell
        
        cell.kickBoardIDLabel.text = userData.rentalList[indexPath.row].kickBoardID
        cell.kickBoardNumberLabel.text = "\(userData.rentalList[indexPath.row].kickBoardNumber)"
        cell.rentalPriceLabel.text = "\(userData.rentalList[indexPath.row].rentalPrice)원"
        cell.rentalStartTimeLabel.text = userData.rentalList[indexPath.row].rentalStartTime
        cell.rentalTimeLabel.text = "\(userData.rentalList[indexPath.row].rentalTotalTime)분"
        
        return cell
    }
    
    // MARK: - tableView의 cell 출력
    func tableView(_ tableView: UITableView, 
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // 대여중이면 section 수 3개 / 대여중이 아니라면 section 수 2개
        if userData.status {
            switch indexPath.section {
            case 0:
                return setUserDefaultCell(tableView, indexPath: indexPath)
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "rentalListCell", for: indexPath) as! RentalListTableViewCell
                cell.kickBoardIDLabel.text = currentRental.kickBoardID
                cell.kickBoardNumberLabel.text = "\(currentRental.kickBoardNumber)"
                cell.rentalPriceLabel.text = "\(currentRental.rentalPrice)원"
                cell.rentalStartTimeLabel.text = currentRental.rentalStartTime
                cell.rentalTimeLabel.text = "\(currentRental.rentalTotalTime)분"
                return cell
            case 2:
                return setUserRentalListCell(tableView, indexPath: indexPath)            
            default:
                fatalError("Unknown section")
            }
        }else {
            switch indexPath.section {
            case 0:
                return setUserDefaultCell(tableView, indexPath: indexPath)
            case 2:
                return setUserRentalListCell(tableView, indexPath: indexPath)
            default:
                fatalError("Unknown section")
            }
        }
    }
    
    
}
