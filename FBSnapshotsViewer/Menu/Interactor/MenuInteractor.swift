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
    /// Note: in resets every notification about new application test run
    fileprivate var testResults: [TestResult] = []
    
    /// Instance of listener for snapshots diff folder notification
    private let snaphotsDiffFolderNotificationListener: SnapshotsViewerApplicationRunNotificationListener
    
    /// Instance of aplication temporary folder finder
    fileprivate let applicationTemporaryFolderFinder: ApplicationTemporaryFolderFinder
    
    /// Instance of aplication snapshot test listener
    fileprivate let applicationSnapshotTestResultListener: ApplicationSnapshotTestResultListener
    
    /// Instance of file manager to be used for internal listeners
    fileprivate let fileManager: FileManager
    
    init(snaphotsDiffFolderNotificationListener: SnapshotsViewerApplicationRunNotificationListener, applicationTemporaryFolderFinder: ApplicationTemporaryFolderFinder, applicationSnapshotTestResultListener: ApplicationSnapshotTestResultListener, fileManager: FileManager = FileManager.default) {
        self.applicationTemporaryFolderFinder = applicationTemporaryFolderFinder
        self.applicationSnapshotTestResultListener = applicationSnapshotTestResultListener
        self.fileManager = fileManager
        self.snaphotsDiffFolderNotificationListener = snaphotsDiffFolderNotificationListener
        self.snaphotsDiffFolderNotificationListener.delegate = self
    }
    
    // MARK: - Helpers
    
    private func startSnapshotTestResultListening(of application: Application) {
        applicationSnapshotTestResultListener.listen(application: application) { [weak self] testResult in
            guard let strongSelf = self else {
                return
            }
            strongSelf.testResults.append(testResult)
            strongSelf.output?.didFind(new: strongSelf.testResults)
        }
    }
}

// MARK: - SnapshotsViewerApplicationRunNotificationListenerDelegate
extension MenuInteractor: SnapshotsViewerApplicationRunNotificationListenerDelegate {
    func snapshotsDiffFolderNotificationListener(_ listener: SnapshotsViewerApplicationRunNotificationListener, didReceiveRunningiOSSimulatorFolder simulatorPath: String, andImageDiffFolder imageDiffPath: String?) {
        testResults = []
        applicationSnapshotTestResultListener.stopListening()
        applicationTemporaryFolderFinder.stopFinding()
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
    
}
