//
//  CityListViewController.swift
//  RnD Assessment
//
//  Created by Idris Sop on 2021/05/17.
//

import UIKit

class CityListViewController: BaseViewController {

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
    
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private var loadingView: UIView!
    
    private lazy var viewModel =  CityListViewModel(delegate: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchCities()
        hideKeyboardWhenTappedAround()
    }
    
}

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
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        selectedReceipt = viewModel.receiptList?[indexPath.row]
//        self.performSegue(withIdentifier: "EditReceiptSegueIdentifier", sender: self)
//    }
}

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

extension CityListViewController: CityListViewModelDelegate {
    
    func refreshContentView() {
        cityTableView.reloadData()
    }
    
    func showLoadingIndicator() {
        self.loadingView.isHidden = false
        self.activityIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        self.loadingView.isHidden = true
        self.activityIndicator.stopAnimating()
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
}
