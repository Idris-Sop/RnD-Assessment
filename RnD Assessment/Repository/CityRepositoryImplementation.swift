//
//  CityRepositoryImplementation.swift
//  RnD Assessment
//
//  Created by Idris Sop on 2021/05/17.
//

import UIKit

class CityRepositoryImplementation: CityRepository {

    func fetchCities(with success: @escaping FetchCitiesCompletionBlock,
                     failure: @escaping CompletionFailureBlock) {
        
        let cachedCities = ManagedCityCache.sharedInstance.citiesList
        if let cities = cachedCities, cities.count > 0 {
            success(cities)
        } else {
            if let path = Bundle.main.path(forResource: "cities", ofType: "json") {
                do {
                    let fileUrl = URL(fileURLWithPath: path)
                    let data = try Data(contentsOf: fileUrl, options: .mappedIfSafe)
                    var cityArray = try JSONDecoder().decode([City].self, from: data)
                    cityArray.sort(by: { $0.cityName?.compare($1.cityName ?? "") == .orderedAscending })
                    ManagedCityCache.sharedInstance.citiesList = cityArray
                    success(cityArray)
                } catch {
                    let dataError = NSError(domain: "The data couldn’t be read due to technical problem.", code: 0, userInfo: nil)
                    failure(dataError)
                }
            }
        }
    }
}
