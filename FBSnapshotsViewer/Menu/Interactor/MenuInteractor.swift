//
//  MenuInteractor.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 05/02/2017.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Foundation
import BoltsSwift

class MenuInteractor {
    weak var output: MenuInteractorOutput?

    /// Currently found test results
    /// Note: it resets every notification about new application test run
    fileprivate var currentlyFoundTestResults: [TestResult] = []

    /// Instance of listener for snapshots diff folder notification
    private let snaphotsDiffFolderNotificationListener: SnapshotsViewerApplicationRunNotificationListener

    /// Instance of aplication temporary folder finder
    fileprivate let applicationTemporaryFolderFinder: ApplicationTemporaryFolderFinder

    /// Instance of aplication snapshot test listener
    fileprivate let applicationSnapshotTestResultListener: ApplicationSnapshotTestResultListener

    init(snaphotsDiffFolderNotificationListener: SnapshotsViewerApplicationRunNotificationListener,
         applicationTemporaryFolderFinder: ApplicationTemporaryFolderFinder,
         applicationSnapshotTestResultListener: ApplicationSnapshotTestResultListener) {
        self.applicationTemporaryFolderFinder = applicationTemporaryFolderFinder
        self.applicationSnapshotTestResultListener = applicationSnapshotTestResultListener
        self.snaphotsDiffFolderNotificationListener = snaphotsDiffFolderNotificationListener
        self.snaphotsDiffFolderNotificationListener.delegate = self
    }

    // MARK: - Helpers

    fileprivate func startSnapshotTestResultListening(of application: Application) {
        applicationSnapshotTestResultListener.listen(application: application) { [weak self] testResult in
            guard let strongSelf = self else {
                return
            }
            strongSelf.currentlyFoundTestResults.append(testResult)
            strongSelf.output?.didFind(new: testResult)
        }
    }
}

// MARK: - SnapshotsViewerApplicationRunNotificationListenerDelegate
extension MenuInteractor: SnapshotsViewerApplicationRunNotificationListenerDelegate {
    func snapshotsDiffFolderNotificationListener(_ listener: SnapshotsViewerApplicationRunNotificationListener, didReceiveRunningiOSSimulatorFolder simulatorPath: String, andImageDiffFolder imageDiffPath: String?) {
        applicationSnapshotTestResultListener.stopListening()
        applicationTemporaryFolderFinder.stopFinding()
        currentlyFoundTestResults.removeAll()
        if let imageDiffPath = imageDiffPath {
            startSnapshotTestResultListening(of: Application(snapshotsDiffFolder: imageDiffPath))
            return
        }
        applicationTemporaryFolderFinder.find(in: simulatorPath) { [weak self] temporaryFolderPath in
            self?.startSnapshotTestResultListening(of: Application(snapshotsDiffFolder: temporaryFolderPath))
        }
    }
}

// MARK: - MenuInteractorInput
extension MenuInteractor: MenuInteractorInput {
    var foundTestResults: [TestResult] {
        return currentlyFoundTestResults
    }
}
