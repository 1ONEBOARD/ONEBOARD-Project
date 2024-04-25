//
//  UserViewController+TableView.swift
//  OneBoardProject
//
//  Created by 배지해 on 4/23/24.
//

import Foundation
import UIKit

extension UserViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    // MARK: - TableView 초기 설정
    func setUserTableView() {
        
        userTableView.delegate = self
        userTableView.dataSource = self
        userTableView.separatorStyle = .none
        
        let nib1 = UINib(nibName: "UserDefaultTableViewCell", bundle: nil)
        let nib2 = UINib(nibName: "RentalListTableViewCell", bundle: nil)
        userTableView.register(nib1, forCellReuseIdentifier: "userDefaultCell")
        userTableView.register(nib2, forCellReuseIdentifier: "rentalListCell")
    }
     
    
    // MARK: - 유저 정보 cell 설정
    func setUserDefaultCell(_ tableView: UITableView,
                            indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "userDefaultCell", for: indexPath) as! UserDefaultTableViewCell
        let cellConfigure: [(String,String)] = [("이름", userName), ("아이디", userID)]
        cell.firstLabel.text = cellConfigure[indexPath.row].0
        cell.LastLabel.text = cellConfigure[indexPath.row].1
        
        return cell
    }
    
    
    // MARK: - 유저 킥보드 렌탈 리스트 cell 설정
    func setUserRentalListCell(_ tableView: UITableView,
                               indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "rentalListCell", for: indexPath) as! RentalListTableViewCell
        
        // 렌탈 리스트에서 값을 가져오는 함수 적어야함.
        
//        cell.kickBoardIDLabel.text = userData.rentalList[indexPath.row].kickBoardID
//        cell.kickBoardNumberLabel.text = "\(userData.rentalList[indexPath.row].kickBoardNumber)"
//        cell.rentalPriceLabel.text = setPriceLabel(price: userData.rentalList[indexPath.row].rentalPrice)
//        cell.rentalStartTimeLabel.text = userData.rentalList[indexPath.row].rentalStartTime
//        if let rentalTotalTime = userData.rentalList[indexPath.row].rentalTotalTime {
//            cell.rentalTimeLabel.text = "\(rentalTotalTime)분"
//        }
        return cell
    }
    
    
    // MARK: - 금액 천단위 설정
    func setPriceLabel(price: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        guard let priceString = numberFormatter.string(from: NSNumber(value: price)) else { return "" }
        return priceString + "원"
    }
    
    
    // MARK: - 테이블 뷰의 Section 수 결정
    func numberOfSections(in tableView: UITableView) -> Int {
        
        // 대여중이면 section 수 3개 / 대여중이 아니라면 section 수 2개
        if userStatus {
            return 3
        }else {
            return 2
        }
    }
    
    
    // MARK: - tableView 헤더 높이 설정
    func tableView(_ tableView: UITableView,
                   heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }

    
    // MARK: - tableView 푸터 높이 설정
    func tableView(_ tableView: UITableView,
                   heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }

    // MARK: - tableView 섹션에 따른 header UI 설정
    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView()
        headerView.backgroundColor = .white
        
        let headerLabel = UILabel(frame: CGRect(x: 20, y: 0, width: tableView.bounds.size.width, height: 45))
        headerLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        headerLabel.textColor = UIColor.black // 텍스트 색상 설정
        
        // 테두리 뷰의 너비 설정
        let borderWidth: CGFloat = tableView.bounds.size.width - 40
        // 테두리 뷰가 수평 중앙에 오도록 x 값 계산
        let borderX: CGFloat = (tableView.bounds.size.width - borderWidth) / 2
        
        let headerBorderView = UIView(frame: CGRect(x: borderX, y: 40, width: borderWidth, height: 2))
        headerBorderView.backgroundColor = .black
        
        // 대여중이면 section 수 3개 / 대여중이 아니라면 section 수 2개
        if userStatus {
            switch section {
            case 0: headerLabel.text = "프로필"
            case 1: headerLabel.text = "대여중"
            case 2: headerLabel.text = "이전 대여 목록"
            default: headerLabel.text = ""
            }
        }else {
            switch section {
            case 0: headerLabel.text = "프로필"
            case 1: headerLabel.text = "이전 대여 목록"
            default: headerLabel.text = ""
            }
        }
        
        headerView.addSubview(headerLabel)
        headerView.addSubview(headerBorderView)
        
        return headerView
    }
    
    
    // MARK: - tableView의 셀의 개수
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        
        // 대여중이면 section 수 3개 / 대여중이 아니라면 section 수 2개
        if userStatus {
            switch section {
            case 0: 2
            case 1: 1
            case 2: 0 // 수정
            default: 0
            }
        }else {
            switch section {
            case 0: 2
            case 1: 0 // 수정
            default: 0
            }
        }
    }
    
    
    // MARK: - tableView의 cell 출력
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // 대여중이면 section 수 3개 / 대여중이 아니라면 section 수 2개
        if userStatus {
            switch indexPath.section {
            case 0:
                return setUserDefaultCell(tableView, indexPath: indexPath)
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "rentalListCell", for: indexPath) as! RentalListTableViewCell
                
                // 현재 킥보드 대여 상태
                cell.kickBoardIDLabel.text = "\(userDefaultsManager.getUserDefaultsKickboardID())"
                cell.kickBoardNumberLabel.text = "\(userDefaultsManager.getUserDefaultsKickboardNumber())"
                
                // 현재 시간 - 킥보드를 빌린 시간 함수를 계산하여 setPriceLabel에 넣어야함.
                // cell.rentalPriceLabel.text = setPriceLabel(price: currentRental.rentalPrice)
                
                cell.rentalStartTimeLabel.text = "\(userDefaultsManager.getUserDefaultsKickboardStartTime())"
                
                // 현재 시간 - 킥보드를 빌린 시간 함수를 계산하여 rentalTotalTime에 넣어야함.
//                if let rentalTotalTime = currentRental.rentalTotalTime {
//                    cell.rentalTimeLabel.text = "\(rentalTotalTime)분"
//                }
                
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
            case 1:
                return setUserRentalListCell(tableView, indexPath: indexPath)
            default:
                fatalError("Unknown section")
            }
        }
    }

    
}
