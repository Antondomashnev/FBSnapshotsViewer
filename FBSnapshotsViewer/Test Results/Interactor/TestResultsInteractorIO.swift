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
    func accept(testResult: SnapshotTestResult)
    func reject(testResult: SnapshotTestResult)
    func copy(testResult: SnapshotTestResult)
}

protocol TestResultsInteractorOutput: class, AutoMockable {
    func didFailToAccept(testResult: SnapshotTestResult, with error: Error)
    func didFailToReject(testResult: SnapshotTestResult, with error: Error)
}
