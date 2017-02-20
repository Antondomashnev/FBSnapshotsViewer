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
    
    /// Instance of folder events listener factory to get listeners from
    fileprivate let folderEventsListenerFactory: FolderEventsListenerFactory
    
    /// Instance of file manager to be used for internal listeners
    fileprivate let fileManager: FileManager
    
    init(snaphotsDiffFolderNotificationListener: SnapshotsViewerApplicationRunNotificationListener, folderEventsListenerFactory: FolderEventsListenerFactory, fileManager: FileManager = FileManager.default) {
        self.folderEventsListenerFactory = folderEventsListenerFactory
        self.fileManager = fileManager
        self.snaphotsDiffFolderNotificationListener = snaphotsDiffFolderNotificationListener
        self.snaphotsDiffFolderNotificationListener.delegate = self
    }
}

// MARK: - SnapshotsViewerApplicationRunNotificationListenerDelegate
extension MenuInteractor: SnapshotsViewerApplicationRunNotificationListenerDelegate {
    func snapshotsDiffFolderNotificationListener(_ listener: SnapshotsViewerApplicationRunNotificationListener, didReceiveRunningiOSSimulatorFolder simulatorPath: String, andImageDiffFolder imageDiffPath: String?) {
        let findRunningApplicationTemporaryFolderTask = FindRunningApplicationTemporaryFolderTask(simulatorApplicationsPath: simulatorPath, folderEventsListenerFactory: folderEventsListenerFactory, fileManager: fileManager)
        findRunningApplicationTemporaryFolderTask.run().continueWith { result in
            print("Found folder at \(result)")
        }
    }
}

// MARK: - MenuInteractorInput
extension MenuInteractor: MenuInteractorInput {
    
}
