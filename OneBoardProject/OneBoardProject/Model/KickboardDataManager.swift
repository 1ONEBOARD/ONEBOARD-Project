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
            Kickboard(kickBoardID: "Pro", kickBoardNumber: 101, kickBoardLocation: (37.5023, 127.0451), kickBoardStatus: false, pricePerMinute: 180),
            Kickboard(kickBoardID: "Pro", kickBoardNumber: 102, kickBoardLocation: (37.5023, 127.0441), kickBoardStatus: false, pricePerMinute: 180),
            Kickboard(kickBoardID: "Pro", kickBoardNumber: 103, kickBoardLocation: (37.5024, 127.0455), kickBoardStatus: false, pricePerMinute: 180),
            Kickboard(kickBoardID: "Pro", kickBoardNumber: 104, kickBoardLocation: (37.5025, 127.0448), kickBoardStatus: false, pricePerMinute: 180),
            Kickboard(kickBoardID: "Basic", kickBoardNumber: 105, kickBoardLocation: (37.5026, 127.0441), kickBoardStatus: false, pricePerMinute: 150),
            Kickboard(kickBoardID: "Basic", kickBoardNumber: 106, kickBoardLocation: (37.5027, 127.0443), kickBoardStatus: false, pricePerMinute: 150),
            Kickboard(kickBoardID: "Basic", kickBoardNumber: 107, kickBoardLocation: (37.5028, 127.0451), kickBoardStatus: false, pricePerMinute: 150),
            Kickboard(kickBoardID: "Pro", kickBoardNumber: 101, kickBoardLocation: (37.3023, 127.0451), kickBoardStatus: false, pricePerMinute: 180),
            Kickboard(kickBoardID: "Pro", kickBoardNumber: 102, kickBoardLocation: (37.3023, 127.0441), kickBoardStatus: false, pricePerMinute: 180),
            Kickboard(kickBoardID: "Pro", kickBoardNumber: 103, kickBoardLocation: (37.3024, 127.0455), kickBoardStatus: false, pricePerMinute: 180),
            Kickboard(kickBoardID: "Pro", kickBoardNumber: 104, kickBoardLocation: (37.3025, 127.0448), kickBoardStatus: false, pricePerMinute: 180),
            Kickboard(kickBoardID: "Basic", kickBoardNumber: 105, kickBoardLocation: (37.3026, 127.0441), kickBoardStatus: false, pricePerMinute: 150),
            Kickboard(kickBoardID: "Basic", kickBoardNumber: 106, kickBoardLocation: (37.3027, 127.0443), kickBoardStatus: false, pricePerMinute: 150),
            Kickboard(kickBoardID: "Basic", kickBoardNumber: 107, kickBoardLocation: (37.3028, 127.0451), kickBoardStatus: false, pricePerMinute: 150),
            Kickboard(kickBoardID: "Pro", kickBoardNumber: 101, kickBoardLocation: (37.4023, 127.1451), kickBoardStatus: false, pricePerMinute: 180),
            Kickboard(kickBoardID: "Pro", kickBoardNumber: 102, kickBoardLocation: (37.4023, 127.1441), kickBoardStatus: false, pricePerMinute: 180),
            Kickboard(kickBoardID: "Pro", kickBoardNumber: 103, kickBoardLocation: (37.4024, 127.1455), kickBoardStatus: false, pricePerMinute: 180),
            Kickboard(kickBoardID: "Pro", kickBoardNumber: 104, kickBoardLocation: (37.4025, 127.1448), kickBoardStatus: false, pricePerMinute: 180),
            Kickboard(kickBoardID: "Basic", kickBoardNumber: 105, kickBoardLocation: (37.4026, 127.1441), kickBoardStatus: false, pricePerMinute: 150),
            Kickboard(kickBoardID: "Basic", kickBoardNumber: 106, kickBoardLocation: (37.4027, 127.1443), kickBoardStatus: false, pricePerMinute: 150),
            Kickboard(kickBoardID: "Basic", kickBoardNumber: 107, kickBoardLocation: (37.4028, 127.1451), kickBoardStatus: false, pricePerMinute: 150)]
    }
    
    mutating func getKickboardData() -> [Kickboard] {
        setKickboardData()
        return kickboardList
    }
}
