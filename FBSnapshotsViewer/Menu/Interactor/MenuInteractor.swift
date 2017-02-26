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
    
    func startSnapshotTestResultListening(of application: Application) {
        applicationSnapshotTestResultListener.listen(application: application) { [weak self] testResult in
            print("Found test result: \(testResult)")
        }
    }
}

// MARK: - SnapshotsViewerApplicationRunNotificationListenerDelegate
extension MenuInteractor: SnapshotsViewerApplicationRunNotificationListenerDelegate {
    func snapshotsDiffFolderNotificationListener(_ listener: SnapshotsViewerApplicationRunNotificationListener, didReceiveRunningiOSSimulatorFolder simulatorPath: String, andImageDiffFolder imageDiffPath: String?) {
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
