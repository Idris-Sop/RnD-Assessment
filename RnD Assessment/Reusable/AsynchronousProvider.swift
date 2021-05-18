//
//  AsynchronousProvider.swift
//  RnD Assessment
//
//  Created by Idris Sop on 2021/05/18.
//

import UIKit

struct AsynchronousProvider {

    private static var asyncRunner : AsynchronousRunner = AsynchronousRunnerImplementation()
    
    public static func runOnConcurrent(_ action: @escaping () -> Void, _ qos: DispatchQoS.QoSClass) {
        asyncRunner.runOnConcurrent(action, qos)
    }
    
    public static func runOnMain(_ action: @escaping () -> Void) {
        asyncRunner.runOnMain(action)
    }

    public static func setAsyncRunner(_ asyncRunner: AsynchronousRunner) {
        self.asyncRunner = asyncRunner
    }
    
    public static func reset() {
        asyncRunner = AsynchronousRunnerImplementation()
    }

}

