//
//  CityListViewModel.swift
//  RnD Assessment
//
//  Created by Idris Sop on 2021/05/17.
//

import UIKit

class CityListViewModel {

    private weak var delegate: CityListViewModelDelegate?
    private var repository: CityRepository?
    private var citiesList = [City]()
    private var filteredCitiesList = [City]()
    private var showFilteredCities: Bool = false
    
    init(delegate: CityListViewModelDelegate) {
        self.delegate = delegate
        self.repository = CityRepositoryImplementation()
    }
    
    func fetchCities() {
        self.delegate?.showLoadingIndicator()
        
        let cachedCities = ManagedCityCache.sharedInstance.citiesList
        if cachedCities?.count ?? 0 > 0 {
            self.citiesList = cachedCities ?? [City]()
            self.delegate?.hideLoadingIndicator()
            self.delegate?.refreshContentView()
        } else {
            AsynchronousProvider.runOnConcurrent({
                self.repository?.fetchCities(with: { [weak self](citiesArray) in
                    AsynchronousProvider.runOnMain {
                        self?.citiesList = citiesArray
                        self?.delegate?.hideLoadingIndicator()
                        ManagedCityCache.sharedInstance.citiesList = self?.citiesList
                        self?.delegate?.refreshContentView()
                    }
                    
                }, failure: { [weak self](error) in
                    AsynchronousProvider.runOnMain {
                        self?.delegate?.hideLoadingIndicator()
                        self?.delegate?.showError(with: error.localizedDescription)
                    }
                    
                })
            }, .userInitiated)
        }
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
        
        AsynchronousProvider.runOnConcurrent ({
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
            AsynchronousProvider.runOnMain {
                self.handleDisplayOfNoRecordsFoundText()
                self.delegate?.refreshContentView()
            }
        }, .userInteractive)
    }
    
    private func handleDisplayOfNoRecordsFoundText() {
        let citiesToDisplay = numberOfCitiesInList() > 0
        if (citiesToDisplay) {
            self.delegate?.hideNoRecordsFoundText()
        } else {
            self.delegate?.showNoRecordsFoundText()
        }
    }
    
    func didSelectedCityAtIndex(index: Int) {
        let selectedCity = (self.showFilteredCities) ? self.filteredCitiesList[index] : self.citiesList[index]
        self.delegate?.navigateToMapViewWith(city: selectedCity)
    }
}
