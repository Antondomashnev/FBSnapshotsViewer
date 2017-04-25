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

    /// Instance of aplication snapshot test listener
    fileprivate let applicationSnapshotTestResultListener: ApplicationSnapshotTestResultListener

    /// Instance of applications test log files listener
    fileprivate let applicationTestLogFilesListener: ApplicationTestLogFilesListener

    init(applicationSnapshotTestResultListener: ApplicationSnapshotTestResultListener,
         applicationTestLogFilesListener: ApplicationTestLogFilesListener) {
        self.applicationTestLogFilesListener = applicationTestLogFilesListener
        self.applicationSnapshotTestResultListener = applicationSnapshotTestResultListener
    }
}

// MARK: - MenuInteractorInput
extension MenuInteractor: MenuInteractorInput {
    var foundTestResults: [SnapshotTestResult] {
        return currentlyFoundTestResults
    }

    func startSnapshotTestResultListening(fromLogFileAt path: String) {
        applicationSnapshotTestResultListener.listen(logFileAt: path) { [weak self] testResult in
            self?.currentlyFoundTestResults.append(testResult)
            self?.output?.didFindNewTestResult(testResult)
        }
    }

    func startXcodeBuildsListening(xcodeDerivedDataFolder: XcodeDerivedDataFolder) {
        applicationTestLogFilesListener.stopListening()
        applicationTestLogFilesListener.listen(xcodeDerivedDataFolder: xcodeDerivedDataFolder.path) { [weak self] path in
            self?.output?.didFindNewTestLogFile(at: path)
        }
    }
}
