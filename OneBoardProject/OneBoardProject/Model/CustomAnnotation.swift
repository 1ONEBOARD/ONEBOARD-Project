//
//  CustomAnnotation.swift
//  OneBoardProject
//
//  Created by 배지해 on 4/28/24.
//

import Foundation
import MapKit

class CustomAnnotation: NSObject, MKAnnotation {
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    var kickBoard: Kickboard
    
    init(title: String, subtitle: String, coordinate: CLLocationCoordinate2D, kickBoard: Kickboard) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
        self.kickBoard = kickBoard
    }
}
