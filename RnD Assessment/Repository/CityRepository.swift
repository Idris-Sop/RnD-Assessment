//
//  CityRepository.swift
//  RnD Assessment
//
//  Created by Idris Sop on 2021/05/17.
//

import UIKit

typealias FetchCitiesCompletionBlock = (_ success: [City]) -> Void
typealias CompletionFailureBlock = (_ error: NSError) -> Void

protocol CityRepository: AnyObject {

    func fetchCities(with success: @escaping FetchCitiesCompletionBlock,
                     failure: @escaping CompletionFailureBlock)
}
