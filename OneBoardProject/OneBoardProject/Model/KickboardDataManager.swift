//
//  KickboardDataManager.swift
//  OneBoardProject
//
//  Created by 배지해 on 4/25/24.
//

import Foundation

struct KickboardDataManager {
    
    private var kickboardList = [Kickboard]()
    
    mutating func setKickboardData() {
        kickboardList = [
            Kickboard(kickBoardID: .oneProA1, kickBoardNumber: 201213, kickBoardLocation: (37.5023, 127.0451), pricePerMinute: 180),
            Kickboard(kickBoardID: .oneProA2, kickBoardNumber: 201214, kickBoardLocation: (37.5023, 127.0441), pricePerMinute: 180),
            Kickboard(kickBoardID: .oneProA2, kickBoardNumber: 201215, kickBoardLocation: (37.5024, 127.0455), pricePerMinute: 180),
            Kickboard(kickBoardID: .oneProA2, kickBoardNumber: 201314, kickBoardLocation: (37.5025, 127.0448), pricePerMinute: 180),
            Kickboard(kickBoardID: .oneBaseA1, kickBoardNumber: 201315, kickBoardLocation: (37.5026, 127.0441), pricePerMinute: 180),
            Kickboard(kickBoardID: .oneBaseA1, kickBoardNumber: 201316, kickBoardLocation: (37.5027, 127.0443), pricePerMinute: 180),
            Kickboard(kickBoardID: .oneBaseA1, kickBoardNumber: 201317, kickBoardLocation: (37.5028, 127.0451), pricePerMinute: 180),
            Kickboard(kickBoardID: .oneProA2, kickBoardNumber: 341239, kickBoardLocation: (37.3023, 127.0451), pricePerMinute: 180),
            Kickboard(kickBoardID: .oneProA2, kickBoardNumber: 341240, kickBoardLocation: (37.3023, 127.0441), pricePerMinute: 180),
            Kickboard(kickBoardID: .oneProA2, kickBoardNumber: 341241, kickBoardLocation: (37.3024, 127.0455), pricePerMinute: 180),
            Kickboard(kickBoardID: .oneProA2, kickBoardNumber: 341242, kickBoardLocation: (37.3025, 127.0448), pricePerMinute: 180),
            Kickboard(kickBoardID: .oneProA1, kickBoardNumber: 124689, kickBoardLocation: (37.3026, 127.0441), pricePerMinute: 180),
            Kickboard(kickBoardID: .oneBaseA2, kickBoardNumber: 124690, kickBoardLocation: (37.3027, 127.0443), pricePerMinute: 180),
            Kickboard(kickBoardID: .oneBaseA2, kickBoardNumber: 124691, kickBoardLocation: (37.3028, 127.0451), pricePerMinute: 180),
            Kickboard(kickBoardID: .oneProA1, kickBoardNumber: 445671, kickBoardLocation: (37.4023, 127.1451), pricePerMinute: 180),
            Kickboard(kickBoardID: .oneProA1, kickBoardNumber: 445672, kickBoardLocation: (37.4023, 127.1441), pricePerMinute: 180),
            Kickboard(kickBoardID: .oneProA1, kickBoardNumber: 445673, kickBoardLocation: (37.4024, 127.1455), pricePerMinute: 180),
            Kickboard(kickBoardID: .oneProA1, kickBoardNumber: 445674, kickBoardLocation: (37.4025, 127.1448), pricePerMinute: 180),
            Kickboard(kickBoardID: .oneBaseA2, kickBoardNumber: 123456, kickBoardLocation: (37.4026, 127.1441), pricePerMinute: 180),
            Kickboard(kickBoardID: .oneBaseA2, kickBoardNumber: 123457, kickBoardLocation: (37.4027, 127.1443), pricePerMinute: 180),
            Kickboard(kickBoardID: .oneBaseA2, kickBoardNumber: 123458, kickBoardLocation: (37.4028, 127.1451), pricePerMinute: 180),
            Kickboard(kickBoardID: .oneBaseA2, kickBoardNumber: 123459, kickBoardLocation: (37.5030, 127.0551), pricePerMinute: 180),
            Kickboard(kickBoardID: .oneBaseA1, kickBoardNumber: 123460, kickBoardLocation: (37.5033, 127.0420), pricePerMinute: 180),
            Kickboard(kickBoardID: .oneBaseA1, kickBoardNumber: 893821, kickBoardLocation: (37.5024, 127.0411), pricePerMinute: 180),
            Kickboard(kickBoardID: .oneBaseA1, kickBoardNumber: 893822, kickBoardLocation: (37.5044, 127.0423), pricePerMinute: 180),
            Kickboard(kickBoardID: .oneProA1, kickBoardNumber: 893823, kickBoardLocation: (37.5026, 127.0447), pricePerMinute: 180),
            Kickboard(kickBoardID: .oneProA2, kickBoardNumber: 893824, kickBoardLocation: (37.5027, 127.0423), pricePerMinute: 180),
            Kickboard(kickBoardID: .oneProA2, kickBoardNumber: 893825, kickBoardLocation: (37.5021, 127.0451), pricePerMinute: 180)]
    }
    
    mutating func getKickboardData() -> [Kickboard] {
        setKickboardData()
        return kickboardList
    }
    
    func getKickboardWithNumber(kickboardNumber: Int) -> Kickboard {
        for i in kickboardList {
            if i.kickBoardNumber == kickboardNumber {
                return i
            }
        }
        print("에러")
        return kickboardList[0]
    }
}
