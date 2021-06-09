//
//  AsynchronousRunner.swift
//  RnD Assessment
//
//  Created by Idris Sop on 2021/05/18.
//

import UIKit

protocol AsynchronousRunner {
    func runOnConcurrent(_ action: @escaping () -> Void, _ qos: DispatchQoS.QoSClass)
    func runOnMain(_ action: @escaping () -> Void)
}

