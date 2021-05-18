//
//  City.swift
//  RnD Assessment
//
//  Created by Idris Sop on 2021/05/18.
//

import UIKit

struct City {
    let cityId: Int?
    let countryCode: String?
    let cityName: String?
    let cityCoordinate: Coordinate?
}

struct Coordinate {
    let latitude: Double?
    let longitude: Double?
}
