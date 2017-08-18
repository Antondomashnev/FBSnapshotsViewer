//
//  TestResultsInteractorIO.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 02/03/2017.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Cocoa

protocol TestResultsInteractorInput: class, AutoMockable {
    var testResults: [SnapshotTestResult] { get }
    func openInKaleidoscope(testResult: SnapshotTestResult)
    func openInXcode(testResult: SnapshotTestResult)
    func swap(testResult: SnapshotTestResult)
}

protocol TestResultsInteractorOutput: class, AutoMockable {
    func didFailToSwap(testResult: SnapshotTestResult, with error: Error)
}
