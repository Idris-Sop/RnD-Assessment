//
//  MockCityRepository.swift
//  RnD AssessmentTests
//
//  Created by Idris Sop on 2021/05/18.
//

import UIKit

@testable import RnD_Assessment

struct MockCityRepositoryExpectation: TestExpectable {
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

class MockCityRepository: NSObject {
    
    private var stubResponseExpectation: [TestExpectable] = [TestExpectable]()
    private let fetchCallersSignature = "fetchCitiesSignature"
    private var isFetchCitiesCallSucces = false
    private var cities = [City]()
    private var error: NSError!
    
    func verify() {
        self.stubResponseExpectation.verify()
    }
    
    func expectFetchCitiesForSuccess(cities: [City]) {
        isFetchCitiesCallSucces = true
        self.cities = cities
        stubResponseExpectation.append(MockCityRepositoryExpectation(count: 1, functionSignature: fetchCallersSignature))
    }
    
    func expectFetchCitiesFailure(error: NSError) {
        isFetchCitiesCallSucces = false
        self.error = error
        stubResponseExpectation.append(MockCityRepositoryExpectation(count: 1, functionSignature: fetchCallersSignature))
    }
}

extension MockCityRepository: CityRepository {
    func fetchCities(with success: @escaping FetchCitiesCompletionBlock, failure: @escaping CompletionFailureBlock) {
        _ = stubResponseExpectation.expectation(for: fetchCallersSignature)
        if isFetchCitiesCallSucces {
            success(self.cities)
        } else {
            failure(self.error)
        }
    }
}
