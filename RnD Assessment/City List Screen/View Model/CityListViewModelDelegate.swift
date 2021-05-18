//
//  CityListViewModelDelegate.swift
//  RnD Assessment
//
//  Created by Idris Sop on 2021/05/17.
//

import UIKit

protocol CityListViewModelDelegate: AnyObject {
    func refreshContentView()
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func showError(with message: String)
    func showNoRecordsFoundText()
    func hideNoRecordsFoundText()
    func navigateToMapViewWith(city: City)
}
