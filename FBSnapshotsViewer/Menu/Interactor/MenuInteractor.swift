//
//  MenuInteractor.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 05/02/2017.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Foundation

class MenuInteractor {
    weak var output: MenuInteractorOutput?

    /// Currently found test results
    /// Note: it resets every notification about new application test run
    fileprivate var currentlyFoundTestResults: [SnapshotTestResult] = []

    /// Dictionary with key:pair - application log path: application snapshot test result listener
    fileprivate typealias ApplicationLogPath = String
    fileprivate var applicationSnapshotTestResultListeners: [ApplicationLogPath: ApplicationSnapshotTestResultListener] = [:]

    /// Instance of aplication snapshot test listener factory
    fileprivate let applicationSnapshotTestResultListenerFactory: ApplicationSnapshotTestResultListenerFactory

    /// Instance of applications test log files listener
    fileprivate let applicationTestLogFilesListener: ApplicationTestLogFilesListener

    init(applicationSnapshotTestResultListenerFactory: ApplicationSnapshotTestResultListenerFactory,
         applicationTestLogFilesListener: ApplicationTestLogFilesListener) {
        self.applicationTestLogFilesListener = applicationTestLogFilesListener
        self.applicationSnapshotTestResultListenerFactory = applicationSnapshotTestResultListenerFactory
    }
}

// MARK: - MenuInteractorInput
extension MenuInteractor: MenuInteractorInput {
    var foundTestResults: [SnapshotTestResult] {
        return currentlyFoundTestResults
    }

    func startSnapshotTestResultListening(fromLogFileAt path: String) {
        if applicationSnapshotTestResultListeners[path] != nil {
            return
        }
        let applicationSnapshotTestResultListener = applicationSnapshotTestResultListenerFactory.applicationSnapshotTestResultListener(forLogFileAt: path)
        applicationSnapshotTestResultListener.startListening { [weak self] testResult in
            self?.currentlyFoundTestResults.insert(testResult, at: 0)
            self?.output?.didFindNewTestResult(testResult)
        }
        applicationSnapshotTestResultListeners[path] = applicationSnapshotTestResultListener
    }

    func startXcodeBuildsListening(xcodeDerivedDataFolder: XcodeDerivedDataFolder) {
        applicationTestLogFilesListener.stopListening()
        applicationTestLogFilesListener.listen(xcodeDerivedDataFolder: xcodeDerivedDataFolder.path) { [weak self] path in
            self?.output?.didFindNewTestLogFile(at: path)
        }
    }
}
