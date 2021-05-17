//
//  ManagedCityCache.swift
//  RnD Assessment
//
//  Created by Idris Sop on 2021/05/17.
//

import UIKit

@objc public class ManagedCityCache: NSObject {
    
    @objc public static let sharedInstance = ManagedCityCache()
    var citiesList: [City]?
    
    func invalidate() {
        citiesList = nil
    }
}
