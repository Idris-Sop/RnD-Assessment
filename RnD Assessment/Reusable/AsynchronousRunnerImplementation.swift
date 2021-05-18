//
//  AsynchronousRunnerImplementation.swift
//  RnD Assessment
//
//  Created by Idris Sop on 2021/05/18.
//

import UIKit

class AsynchronousRunnerImplementation: NSObject, AsynchronousRunner {
    
    public func runOnConcurrent(_ action: @escaping () -> Void, _ qos: DispatchQoS.QoSClass) {
        DispatchQueue.global(qos: qos).async(execute: action)
    }
    
    public func runOnMain(_ action: @escaping () -> Void) {
        DispatchQueue.main.async(execute: action)
    }
}
