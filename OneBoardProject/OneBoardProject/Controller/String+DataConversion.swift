//
//  String+DataConversion.swift
//  OneBoardProject
//
//  Created by 배지해 on 4/25/24.
//

import Foundation

extension String {
    
    mutating func setDate(_ date: Date, format: String = "yyyy.mm.dd hh:mm a") {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        self = formatter.string(from: date)
    }
    
    func toDate(format: String = "yyyy.mm.dd hh:mm a") -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.date(from: self)
    }
}
