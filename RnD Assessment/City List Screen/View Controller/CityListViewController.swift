//
//  CityListViewController.swift
//  RnD Assessment
//
//  Created by Idris Sop on 2021/05/17.
//

import UIKit

class CityListViewController: BaseViewController {

    // MARK: IBOutlet(s)
    
    @IBOutlet private var citySearchBar: UISearchBar! {
        didSet {
            citySearchBar.delegate = self
        }
    }
    
    @IBOutlet private var cityTableView: UITableView! {
        didSet {
            cityTableView.rowHeight = UITableView.automaticDimension
            cityTableView.estimatedRowHeight = UITableView.automaticDimension
            cityTableView.tableFooterView = UIView(frame: .zero)
        }
    }
    
    @IBOutlet private var noRecordFoundLabel: UILabel!

    // MARK: Dependencies
    private var selectedCity: City?
    private lazy var viewModel =  CityListViewModel(delegate: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.noRecordFoundLabel.isHidden = true
        viewModel.fetchCities()
        hideKeyboardWhenTappedAround()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "cityMapViewSegueIdentifier" {
            let cityMapViewController = segue.destination as? CityMapViewController
            guard let city = selectedCity else {
                return
            }
            cityMapViewController?.setupPointAnnotationWith(city: city)
        }
    }
}

// MARK: UITableViewDelegate, UITableViewDataSource

extension CityListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCitiesInList()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let customCell = tableView.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath) as? CityTableViewCell
        let currentCity = viewModel.cityAtIndex(index: indexPath.row)

        customCell?.populateCellWith(cityName: currentCity.cityName ?? "", countryCode: currentCity.countryCode ?? "", latitude: currentCity.cityCoordinate?.latitude ?? 0.00, longitude: currentCity.cityCoordinate?.longitude ?? 0.00)
        return customCell ?? CityTableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectedCityAtIndex(index: indexPath.row)
    }
}

// MARK: UISearchBarDelegate

extension CityListViewController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchCityWithKeyword(searchString: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

// MARK: CityListViewModelDelegate

extension CityListViewController: CityListViewModelDelegate {
    
    func refreshContentView() {
        cityTableView.reloadData()
    }
    
    func showLoadingIndicator() {
        self.showLoadingActivityIndicator()
    }
    
    func hideLoadingIndicator() {
        self.hideLoadingActivityIndicator()
    }
    
    func showError(with message: String) {
        self.showErrorMessage(errorMessage: message)
    }
    
    func showNoRecordsFoundText() {
        self.noRecordFoundLabel.isHidden = false
        self.cityTableView.isHidden = true
    }
    
    func hideNoRecordsFoundText() {
        self.noRecordFoundLabel.isHidden = true
        self.cityTableView.isHidden = false
    }
    
    func navigateToMapViewWith(city: City) {
        self.selectedCity = city
        self.performSegue(withIdentifier: "cityMapViewSegueIdentifier", sender: self)
    }
}
