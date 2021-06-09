//
//  CityListViewModel.swift
//  RnD Assessment
//
//  Created by Idris Sop on 2021/05/17.
//

import UIKit

class CityListViewModel {

    private weak var delegate: CityListViewModelDelegate?
    private let repository: CityRepository
    private var citiesList = [City]()
    
    init(repository: CityRepository = CityRepositoryImplementation(), delegate: CityListViewModelDelegate) {
        self.delegate = delegate
        self.repository = repository
    }
    
    func fetchCities() {
        self.delegate?.showLoadingIndicator()
        AsynchronousProvider.runOnConcurrent({
            self.repository.fetchCities(with: { [weak self](citiesArray) in
                AsynchronousProvider.runOnMain {
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
        return self.citiesList.count
    }
    
    func cityAtIndex(index: Int) -> City {
        return self.citiesList[index]
    }
    
    func searchCityWithKeyword(searchString: String) {
        self.citiesList = [City]()
        AsynchronousProvider.runOnConcurrent ({
            self.citiesList = self.repository.searchForCities(with: searchString)
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
        self.delegate?.navigateToMapViewWith(city: self.citiesList[index])
    }
}

extension String {
    func ingoreCaseContains(_ searchable: String) -> Bool {
        return self.lowercased().contains(searchable.lowercased())
    }
}

