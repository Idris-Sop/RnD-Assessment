//
//  DummyAsynchronousRunner.swift
//  RnD Assessment
//
//  Created by Idris Sop on 2021/05/18.
//

import UIKit
 
class DummyAsynchronousRunner: AsynchronousRunner {

    func runOnConcurrent(_ action: @escaping () -> Void, _ qos: DispatchQoS.QoSClass) {
        action()
    }

    func runOnMain(_ action: @escaping () -> Void) {
        action()
    }
}

