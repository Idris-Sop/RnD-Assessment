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
    
    init(repository: CityRepository = CityRepositoryImplementation(), delegate: CityListViewModelDelegate) {
        self.delegate = delegate
        self.repository = repository
    }
    
    func fetchCities() {
        self.delegate?.showLoadingIndicator()
        AsynchronousProvider.runOnConcurrent({
            self.repository?.fetchCities(with: { [weak self](citiesArray) in
                AsynchronousProvider.runOnMain {
                    self?.filteredCitiesList = citiesArray
                    self?.citiesList = citiesArray
                    self?.delegate?.hideLoadingIndicator()
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
    
    func numberOfCitiesInList() -> Int {
        return self.filteredCitiesList.count
    }
    
    func cityAtIndex(index: Int) -> City {
        return self.filteredCitiesList[index]
    }
    
    func searchCityWithKeyword(searchString: String) {
        self.filteredCitiesList = [City]()
        let cities = self.citiesList
        
        AsynchronousProvider.runOnConcurrent ({
            if searchString.isEmpty {
                self.filteredCitiesList = cities
            } else {
                self.filteredCitiesList = cities.filter {return self.doesCityContainSearchData(city: $0, search: searchString)}
            }
            AsynchronousProvider.runOnMain {
                self.handleDisplayOfNoRecordsFoundText()
                self.delegate?.refreshContentView()
            }
        }, .userInteractive)
    }
    
    private func doesCityContainSearchData(city: City, search: String) -> Bool {
        return city.cityName?.ingoreCaseContains(search) ?? false || city.countryCode?.ingoreCaseContains(search) ?? false
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
        self.delegate?.navigateToMapViewWith(city: self.filteredCitiesList[index])
    }
}

extension String {
    func ingoreCaseContains(_ searchable: String) -> Bool {
        return self.lowercased().contains(searchable.lowercased())
    }
}
