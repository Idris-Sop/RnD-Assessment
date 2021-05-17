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
        
        if let path = Bundle.main.path(forResource: "cities", ofType: "json") {
            do {
                let fileUrl = URL(fileURLWithPath: path)
                let data = try Data(contentsOf: fileUrl, options: .mappedIfSafe)
                let jsonResponseArray = try JSONSerialization.jsonObject(with: data as Data, options: []) as? Array<Any>
                var cityArray = [City]()
                for (_, city) in (((jsonResponseArray)?.enumerated())!) {
                    if let  currentCity = city as? [String : Any] {
                        let cityCoordinate = currentCity["coord"] as? [String : Any]
                        let cityResponseModel = City(cityId: currentCity["_id"] as? Int, countryCode: currentCity["country"] as? String, cityName: currentCity["name"] as? String, cityCoordinate: Coordinate(latitude: cityCoordinate?["lat"] as? Double, longitude: cityCoordinate?["lon"] as? Double))
                        cityArray.append(cityResponseModel)
                    }
                }
                cityArray.sort(by: { $0.cityName?.compare($1.cityName ?? "") == .orderedAscending })
                success(cityArray)
            } catch {
                let dataError = NSError(domain: "The data couldn’t be read due to technical problem.", code: 0, userInfo: nil)
                failure(dataError)
            }
        }
    }
}
