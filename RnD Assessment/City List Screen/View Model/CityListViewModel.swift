//
//  CityListViewModel.swift
//  RnD Assessment
//
//  Created by Idris Sop on 2021/05/17.
//

import UIKit

class CityListViewModel: NSObject {

    private weak var delegate: CityListViewModelDelegate?
    private var repository: CityRepository?
    private var citiesList = [City]()
    private var filteredCitiesList = [City]()
    private var showFilteredCities: Bool = false
    
    init(delegate: CityListViewModelDelegate) {
        super.init()
        self.delegate = delegate
        self.repository = CityRepositoryImplementation()
    }
    
    func fetchCities() {
        self.delegate?.showLoadingIndicator()
        let cachedCities = ManagedCityCache.sharedInstance.citiesList
        if cachedCities?.count ?? 0 > 0 {
            self.citiesList = cachedCities ?? [City]()
        } else {
            self.repository?.fetchCities(with: { [weak self](citiesArray) in
                self?.citiesList = citiesArray
                ManagedCityCache.sharedInstance.citiesList = self?.citiesList
            }, failure: { [weak self](error) in
                self?.delegate?.showError(with: error.localizedDescription)
            })
        }
        self.delegate?.refreshContentView()
        self.delegate?.hideLoadingIndicator()
    }
    
    func numberOfCitiesInList() -> Int {
        return (self.showFilteredCities) ? (self.filteredCitiesList.count) : (self.citiesList.count)
    }
    
    func cityAtIndex(index: Int) -> City {
        return (self.showFilteredCities) ? self.filteredCitiesList[index] : self.citiesList[index]
    }
    
    func searchCityWithKeyword(searchString: String) {
        self.showFilteredCities = true
        self.filteredCitiesList = [City]()
        let cities = self.citiesList
        
        if searchString.isEmpty {
            self.filteredCitiesList = cities
        } else {
            self.filteredCitiesList = cities.filter {(
                $0.cityName?.lowercased().contains(searchString.lowercased())
            ) ?? false}
            
            if self.filteredCitiesList.count == 0 {
                self.filteredCitiesList = cities.filter {(
                    $0.countryCode?.lowercased().contains(searchString.lowercased())
                ) ?? false}
            }
        }
        handleDisplayOfNoRecordsFoundText()
        self.delegate?.refreshContentView()
    }
    
    private func handleDisplayOfNoRecordsFoundText() {
        let citiesToDisplay = numberOfCitiesInList() > 0
        if (citiesToDisplay) {
            self.delegate?.hideNoRecordsFoundText()
        } else {
            self.delegate?.showNoRecordsFoundText()
        }
    }
}
