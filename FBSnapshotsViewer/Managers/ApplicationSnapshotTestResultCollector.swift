//
//  ApplicationSnapshotTestResultCollector.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 26/02/2017.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Foundation

protocol ApplicationSnapshotTestResultCollectorOutput {
    func applicationSnapshotTestResultCollector(_ collector: ApplicationSnapshotTestResultCollector, didCollect testResult: TestResult)
}

class ApplicationSnapshotTestResultCollector {
    var pendingTestResults: [String: TestResult] = [:]
}
