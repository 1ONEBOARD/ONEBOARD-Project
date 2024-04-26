//
//  Data.swift
//  OneBoardProject
//
//  Created by 김건응 on 4/24/24.
//

import Foundation

struct Kickboard {
        var kickBoardID: String
        var kickBoardNumber: Int
        var kickBoardLocation: (Double, Double)
        var kickBoardStatus: Bool
        var pricePerMinute: Int
}

struct Rentaldata {
  var kickBoardID: String
  var kickBoardNumber: Int
  var rentalStartTime: String
  var rentalTotalTime: Int?
  var rentalPrice: Int
}
