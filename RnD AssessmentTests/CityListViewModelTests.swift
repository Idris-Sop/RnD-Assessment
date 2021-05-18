//
//  RnD_AssessmentTests.swift
//  RnD AssessmentTests
//
//  Created by Idris Sop on 2021/05/17.
//

import XCTest
@testable import RnD_Assessment

class CityListViewModelTests: XCTestCase {

    private var mockCityRepository = MockCityRepository()
    private var viewModelUnderTest : CityListViewModel!
    private var mockDelegate = MockCityViewModelDelegate()
    
    
    override func setUpWithError() throws {
        super.setUp()
        AsynchronousProvider.setAsyncRunner(DummyAsynchronousRunner())
        viewModelUnderTest = CityListViewModel(repository: mockCityRepository, delegate: mockDelegate)
    }

    override func tearDownWithError() throws {
        mockCityRepository.verify()
        mockDelegate.verify()
        AsynchronousProvider.reset()
        super.tearDown()
    }

    func testThatWhenFetchCitiesIsCalledThenShowLoadingIndicatorShouldBeCalled() {
        mockFetchingCitiesSuccessfully()
        viewModelUnderTest.fetchCities()
        mockDelegate.verifyShowLoadingIndicator(count: 1)
    }
    
    func testThatWhenFetchCitiesWithSuccessIsCalledThenHideLoadingIndicatorShouldBeCalled() {
        mockFetchingCitiesSuccessfully()
        viewModelUnderTest.fetchCities()
        mockDelegate.verifyHideLoadingIndicator(count: 1)
    }
    
    func testThatWhenFetchCitiesWithSuccessIsCalledThenRefreshContentViewShouldBeCalled() {
        mockFetchingCitiesSuccessfully()
        viewModelUnderTest.fetchCities()
        mockDelegate.verifyRefreshContentView(count: 1)
    }
    
    func testThatWhenFetchCitiesWithFailureIsCalledThenHideLoadingIndicatorViewShouldBeCalled() {
        mockFetchingCitiesFailure()
        viewModelUnderTest.fetchCities()
        mockDelegate.verifyHideLoadingIndicator(count: 1)
    }
    
    func testThatWhenFetchCitiesWithFailureIsCalledThenShowErrorShouldBeCalled() {
        mockFetchingCitiesFailure()
        viewModelUnderTest.fetchCities()
        mockDelegate.verifytShowError(count: 1)
    }
    
    func testThatWhenNumberOfCitiesInListIsCalledAndShowFilteredCitiesIsFalseThenReturnCitiesListCount() {
        let expectedCities = mockCitiesData()
        mockFetchingCitiesSuccessfully()
        viewModelUnderTest.fetchCities()
        XCTAssertEqual(expectedCities.count, viewModelUnderTest.numberOfCitiesInList())
    }
    
    func testThatWhenNumberOfCitiesInListIsCalledAndShowFilteredCitiesIsTrueThenReturnFilteredCitiesListCount() {
        mockFilterWithRecord()
        mockFetchingCitiesSuccessfully()
        viewModelUnderTest.fetchCities()
        viewModelUnderTest.searchCityWithKeyword(searchString: "PA")
        XCTAssertEqual(2, viewModelUnderTest.numberOfCitiesInList())
    }
    
    func testThatWhenNumberOfCitiesInListIsCalledAndShowFilteredCitiesIsTrueThenReturnZeroCount() {
        mockFilterWithNoRecordFound()
        mockFetchingCitiesSuccessfully()
        viewModelUnderTest.fetchCities()
        viewModelUnderTest.searchCityWithKeyword(searchString: "GH")
        XCTAssertEqual(0, viewModelUnderTest.numberOfCitiesInList())
    }
    
    func testThatWhenCityAtIndexIsCalledAndShowFilteredCitiesIsFalseThenReturnCitiesListCount() {
        let expectedCities = mockCitiesData()
        mockFetchingCitiesSuccessfully()
        viewModelUnderTest.fetchCities()
        XCTAssertEqual(expectedCities[0], viewModelUnderTest.cityAtIndex(index: 0))
        XCTAssertEqual(expectedCities[1], viewModelUnderTest.cityAtIndex(index: 1))
        XCTAssertEqual(expectedCities[2], viewModelUnderTest.cityAtIndex(index: 2))
    }
    
    func testThatWhenCityAtIndexIsCalledIsCalledAndShowFilteredCitiesIsTrueThenReturnFilteredCitiesListCount() {
        let expectedCities = mockCitiesData()
        mockFilterWithRecord()
        mockFetchingCitiesSuccessfully()
        viewModelUnderTest.fetchCities()
        viewModelUnderTest.searchCityWithKeyword(searchString: "PA")
        XCTAssertEqual(expectedCities[0], viewModelUnderTest.cityAtIndex(index: 0))
        XCTAssertEqual(expectedCities[1], viewModelUnderTest.cityAtIndex(index: 1))
    }
    
    func testThatWhenCityAtIndexIsCalledAndShowFilteredCitiesIsTrueThenReturnZeroCount() {
        mockFilterWithNoRecordFound()
        mockFetchingCitiesSuccessfully()
        viewModelUnderTest.fetchCities()
        viewModelUnderTest.searchCityWithKeyword(searchString: "GH")
        XCTAssertEqual(0, viewModelUnderTest.numberOfCitiesInList())
    }
    
    func testThatWhenDidSelectedCityAtIndexIsCalledThenNavigateToMapViewShouldBeCalled() {
        mockDelegate.expectNavigateToMapView()
        mockFetchingCitiesSuccessfully()
        viewModelUnderTest.fetchCities()
        viewModelUnderTest.didSelectedCityAtIndex(index: 1)
        mockDelegate.verifyNavigateToMapView(count: 1)
    }
    
    func testThatWhenSearchCityWithKeywordIsCalledAndKeywordFoundThenHideNoRecordsFoundTextShouldBeCalled() {
        mockFilterWithRecord()
        mockFetchingCitiesSuccessfully()
        viewModelUnderTest.fetchCities()
        viewModelUnderTest.searchCityWithKeyword(searchString: "PA")
        mockDelegate.verifyHideNoRecordsFound(count: 1)
    }
    
    func testThatWhenSearchCityWithKeywordIsCalledAndKeywordNOTFoundThenHideNoRecordsFoundTextShouldBeCalled() {
        mockFilterWithNoRecordFound()
        mockFetchingCitiesSuccessfully()
        viewModelUnderTest.fetchCities()
        viewModelUnderTest.searchCityWithKeyword(searchString: "GH")
        mockDelegate.verifyShowNoRecordsFound(count: 1)
    }
    
    func mockFetchingCitiesSuccessfully() {
        mockDelegate.expectShowLoadingIndicator()
        mockDelegate.expectHideLoadingIndicator()
        mockDelegate.expectRefreshContentView()
        stubFetchCitiesSuccess()
    }
    
    func mockFetchingCitiesFailure() {
        mockDelegate.expectShowLoadingIndicator()
        mockDelegate.expectHideLoadingIndicator()
        mockDelegate.expectShowError(error: mockError())
        stubFetchCitiesFailure()
    }
    
    func mockFilterWithRecord() {
        mockDelegate.expectHideNoRecordsFound()
        mockDelegate.expectRefreshContentView()
    }
    
    func mockFilterWithNoRecordFound() {
        mockDelegate.expectShowNoRecordsFound()
        mockDelegate.expectRefreshContentView()
    }
    
    func stubFetchCitiesSuccess() {
        mockCityRepository.expectFetchCitiesForSuccess(cities: mockCitiesData())
    }
    
    func stubFetchCitiesFailure() {
        mockCityRepository.expectFetchCitiesFailure(error: mockError())
    }
    
    func mockCitiesData() -> [City] {
        return [City(cityId: 1, countryCode: "ES", cityName: "Spanish", cityCoordinate: Coordinate(latitude: 52.609039, longitude: 13.48117)),
        City(cityId: 2, countryCode: "FR", cityName: "Paris", cityCoordinate: Coordinate(latitude: 26.474443, longitude: 64.656113)),
        City(cityId: 3, countryCode: "SA", cityName: "Johannesburg", cityCoordinate: Coordinate(latitude: 43.06451, longitude: 37.491112))]
    }
    
    func mockError() -> NSError {
        return NSError(domain: "Failed to fetch", code: 0)
    }
    
}
