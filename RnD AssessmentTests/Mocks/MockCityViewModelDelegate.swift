//
//  MockCityViewModelDelegate.swift
//  RnD AssessmentTests
//
//  Created by Idris Sop on 2021/05/18.
//

import XCTest
@testable import RnD_Assessment

struct MockCityViewModelDelegateExpectation: TestExpectable {
    var expectedCount: Int
    var identifier: String
    var actualCount = 0
    var alreadyInvoked = false
    var expectedResult: Any?
    
    init(count: Int, functionSignature: String) {
        self.identifier = functionSignature
        self.expectedCount = count
    }
}

class MockCityViewModelDelegate: NSObject {
    private var stubCityViewModelDelegateExpectation: [TestExpectable] = [TestExpectable]()
    private var invocation =  [String:Int]()
    private var error: NSError!
    private let refreshContentViewSignature = "refreshContentViewSignature"
    private let showLoadingIndicatorSignature = "showLoadingIndicatorSignature"
    private let hideLoadingIndicatorSignature = "hideLoadingIndicatorSignature"
    private let showErrorSignature = "showErrorSignature"
    private let showNoRecordsFoundTextSignature = "showNoRecordsFoundTextSignature"
    private let hideNoRecordsFoundTextSignature = "hideNoRecordsFoundTextSignature"
    private let navigateToMapViewWithSignature = "navigateToMapViewWithSignature"
    
    func verify() {
        self.stubCityViewModelDelegateExpectation.verify()
    }
    
    func verifyRefreshContentView(count: Int) {
        stubCityViewModelDelegateExpectation.verifyExpectation(for: refreshContentViewSignature, count: count)
    }
    
    func expectRefreshContentView() {
        stubCityViewModelDelegateExpectation.append(MockCityViewModelDelegateExpectation(count: 1, functionSignature: refreshContentViewSignature))
    }
    
    func verifyShowLoadingIndicator(count: Int) {
        stubCityViewModelDelegateExpectation.verifyExpectation(for: showLoadingIndicatorSignature, count: count)
    }
    
    func expectShowLoadingIndicator() {
        stubCityViewModelDelegateExpectation.append(MockCityViewModelDelegateExpectation(count: 1, functionSignature: showLoadingIndicatorSignature))
    }
    
    func verifyHideLoadingIndicator(count: Int) {
        stubCityViewModelDelegateExpectation.verifyExpectation(for: hideLoadingIndicatorSignature, count: count)
    }
    
    func expectHideLoadingIndicator() {
        stubCityViewModelDelegateExpectation.append(MockCityViewModelDelegateExpectation(count: 1, functionSignature: hideLoadingIndicatorSignature))
    }
    
    func verifytShowError(count: Int) {
        stubCityViewModelDelegateExpectation.verifyExpectation(for: showErrorSignature, count: count)
    }
    
    func expectShowError(error: NSError) {
        self.error = error
        stubCityViewModelDelegateExpectation.append(MockCityViewModelDelegateExpectation(count: 1, functionSignature: showErrorSignature))
    }

    func verifyShowNoRecordsFound(count: Int) {
        stubCityViewModelDelegateExpectation.verifyExpectation(for: showNoRecordsFoundTextSignature, count: count)
    }
    
    func expectShowNoRecordsFound() {
        stubCityViewModelDelegateExpectation.append(MockCityViewModelDelegateExpectation(count: 1, functionSignature: showNoRecordsFoundTextSignature))
    }
    
    func verifyHideNoRecordsFound(count: Int) {
        stubCityViewModelDelegateExpectation.verifyExpectation(for: hideNoRecordsFoundTextSignature, count: count)
    }
    
    func expectHideNoRecordsFound() {
        stubCityViewModelDelegateExpectation.append(MockCityViewModelDelegateExpectation(count: 1, functionSignature: hideNoRecordsFoundTextSignature))
    }
    
    func verifyNavigateToMapView(count: Int) {
        stubCityViewModelDelegateExpectation.verifyExpectation(for: navigateToMapViewWithSignature, count: count)
    }
    
    func expectNavigateToMapView() {
        stubCityViewModelDelegateExpectation.append(MockCityViewModelDelegateExpectation(count: 1, functionSignature: navigateToMapViewWithSignature))
    }
}

extension MockCityViewModelDelegate: CityListViewModelDelegate {
   
    func refreshContentView() {
        _ = stubCityViewModelDelegateExpectation.expectation(for: refreshContentViewSignature)
    }
    
    func showLoadingIndicator() {
        invocation[showLoadingIndicatorSignature] = invocation[showLoadingIndicatorSignature] ?? 0 + 1
        _ = stubCityViewModelDelegateExpectation.expectation(for: showLoadingIndicatorSignature)
    }
    
    func hideLoadingIndicator() {
        invocation[hideLoadingIndicatorSignature] = invocation[hideLoadingIndicatorSignature] ?? 0 + 1
        _ = stubCityViewModelDelegateExpectation.expectation(for: hideLoadingIndicatorSignature)
    }
    
    func showError(with message: String) {
        XCTAssertEqual(message, error!.localizedDescription)
        _ = stubCityViewModelDelegateExpectation.expectation(for: showErrorSignature)
    }
    
    
    func showNoRecordsFoundText() {
        _ = stubCityViewModelDelegateExpectation.expectation(for: showNoRecordsFoundTextSignature)
    }
    
    func hideNoRecordsFoundText() {
        _ = stubCityViewModelDelegateExpectation.expectation(for: hideNoRecordsFoundTextSignature)
    }
    
    func navigateToMapViewWith(city: City) {
        _ = stubCityViewModelDelegateExpectation.expectation(for: navigateToMapViewWithSignature)
    }
}

