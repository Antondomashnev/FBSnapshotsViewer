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
    fileprivate let applicationTemporaryFolderFinder: RunningApplicationTemporaryFolderFinder
    
    /// Instance of file manager to be used for internal listeners
    fileprivate let fileManager: FileManager
    
    init(snaphotsDiffFolderNotificationListener: SnapshotsViewerApplicationRunNotificationListener, applicationTemporaryFolderFinder: RunningApplicationTemporaryFolderFinder, fileManager: FileManager = FileManager.default) {
        self.applicationTemporaryFolderFinder = applicationTemporaryFolderFinder
        self.fileManager = fileManager
        self.snaphotsDiffFolderNotificationListener = snaphotsDiffFolderNotificationListener
        self.snaphotsDiffFolderNotificationListener.delegate = self
    }
}

// MARK: - SnapshotsViewerApplicationRunNotificationListenerDelegate
extension MenuInteractor: SnapshotsViewerApplicationRunNotificationListenerDelegate {
    func snapshotsDiffFolderNotificationListener(_ listener: SnapshotsViewerApplicationRunNotificationListener, didReceiveRunningiOSSimulatorFolder simulatorPath: String, andImageDiffFolder imageDiffPath: String?) {
        applicationTemporaryFolderFinder.find(in: simulatorPath) { temporaryFolderPath in
            print("Found temporary folder path \(temporaryFolderPath). Hoooray!!!")
        }
    }
}

// MARK: - MenuInteractorInput
extension MenuInteractor: MenuInteractorInput {
    
}
