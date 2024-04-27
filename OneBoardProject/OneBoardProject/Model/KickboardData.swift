//
//  KickboardData.swift
//  OneBoardProject
//
//  Created by CaliaPark on 4/22/24.
//

import Foundation

struct Kickboard {
    var kickBoardID: KickboardID
    var kickBoardNumber: Int
    var kickBoardLocation: (Double, Double)
    var pricePerMinute: Int
}

enum KickboardID: String {
    case oneProA1 = "One-Pro-A1"
    case oneProA2 = "One-Pro-A2"
    case oneBaseA1 = "One-Basic-A1"
    case oneBaseA2 = "One-Basic-A2"
}
