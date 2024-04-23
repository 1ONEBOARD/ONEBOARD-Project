//
//  User.swift
//  OneBoardProject
//
//  Created by 배지해 on 4/23/24.
//

import Foundation

struct User {
    var userName: String
    var id: String
    var password: String
    var status: Bool
    var rentalList: [Rental]
}
