//
//  CityRepository.swift
//  RnD Assessment
//
//  Created by Idris Sop on 2021/05/17.
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

typealias FetchCitiesCompletionBlock = (_ success: [City]) -> Void
typealias CompletionFailureBlock = (_ error: NSError) -> Void

protocol CityRepository: class {

    func fetchCities(with success: @escaping FetchCitiesCompletionBlock,
                     failure: @escaping CompletionFailureBlock)
}
