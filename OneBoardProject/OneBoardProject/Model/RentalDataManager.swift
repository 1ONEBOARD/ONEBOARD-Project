//
//  RentalDataManager.swift
//  OneBoardProject
//
//  Created by 배지해 on 4/25/24.
//

import Foundation
import UIKit
import CoreData

struct RentalDataManager {
    
    // 데이터 매니저
    static let shared = RentalDataManager()
    private init() {}
    
    // 앱 델리게이트
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    // 임시저장소
    lazy var context = appDelegate?.persistentContainer.viewContext
    
    // 엔터티 이름 (코어 데이터에 저장된 객체)
    let modelName: String = "KickboardRental"
    
    
    // MARK: - 킥보드 렌탈 데이터 저장
    
    mutating func createRentalData(data: Rental) {
        guard let context = context,
              let entity = NSEntityDescription.entity(forEntityName: modelName, in: context) else {
            return
        }
        
        // NSManagedObject 생성
        let newRentalData = NSManagedObject(entity: entity, insertInto: context)
        
        // 속성 값 설정
        newRentalData.setValue(data.userID, forKey: "userID")
        newRentalData.setValue(data.rentalTotalTime, forKey: "rentalTotalTime")
        newRentalData.setValue(data.rentalStartTime, forKey: "rentalStartTime")
        newRentalData.setValue(data.kickBoardID, forKey: "kickBoardID")
        newRentalData.setValue(data.kickBoardNumber, forKey: "kickBoardNumber")
        newRentalData.setValue(data.rentalPrice, forKey: "rentalPrice")
        
        // 변경 사항 저장
        do {
            try context.save()
            print("RentalData created successfully!")
        } catch {
            print("Error creating RentalData: \(error)")
        }
    }
    
    
    // MARK: - 킥보드 렌탈 데이터 가져오기
    
    mutating func getTodoListCoreData(userID: String) -> [KickboardRental] {
        var rentalData = [KickboardRental]()
        
        guard let context = context else {
            return rentalData
        }
        
        let fetchRequest: NSFetchRequest<KickboardRental> = KickboardRental.fetchRequest()
        
        let predicate = NSPredicate(format: "userID == %@", userID)
        fetchRequest.predicate = predicate
        
        let sortDescriptor = NSSortDescriptor(key: "rentalStartTime", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            rentalData = try context.fetch(fetchRequest)
        } catch {
            print("Error fetching RentalData: \(error)")
        }
        
        return rentalData
    }
}
