//
//  City.swift
//  RnD Assessment
//
//  Created by Idris Sop on 2021/05/18.
//

import UIKit

struct City: Codable, Equatable {
    let cityId: Int?
    let countryCode: String?
    let cityName: String?
    let cityCoordinate: Coordinate?
    
    enum CodingKeys: String, CodingKey {
        case cityId = "_id"
        case countryCode = "country"
        case cityName = "name"
        case cityCoordinate = "coord"
    }
}

struct Coordinate: Codable, Equatable {
    let latitude: Double?
    let longitude: Double?
    
    enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lon"
    }
}
