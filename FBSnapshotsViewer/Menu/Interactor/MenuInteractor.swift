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
    
    /// Instance of file manager to be used for internal listeners
    fileprivate let fileManager: FileManager
    
    /// Currently testing iOS application in iOS simulator
    fileprivate var currentlyApplication: Application? = nil
    
    init(snaphotsDiffFolderNotificationListener: SnapshotsViewerApplicationRunNotificationListener, applicationTemporaryFolderFinder: ApplicationTemporaryFolderFinder, fileManager: FileManager = FileManager.default) {
        self.applicationTemporaryFolderFinder = applicationTemporaryFolderFinder
        self.fileManager = fileManager
        self.snaphotsDiffFolderNotificationListener = snaphotsDiffFolderNotificationListener
        self.snaphotsDiffFolderNotificationListener.delegate = self
    }
}

// MARK: - SnapshotsViewerApplicationRunNotificationListenerDelegate
extension MenuInteractor: SnapshotsViewerApplicationRunNotificationListenerDelegate {
    func snapshotsDiffFolderNotificationListener(_ listener: SnapshotsViewerApplicationRunNotificationListener, didReceiveRunningiOSSimulatorFolder simulatorPath: String, andImageDiffFolder imageDiffPath: String?) {
        if let imageDiffPath = imageDiffPath {
            currentlyApplication = Application(snapshotsDiffFolder: imageDiffPath)
        }
        else {
            
        }
        
        applicationTemporaryFolderFinder.find(in: simulatorPath) { [weak self] temporaryFolderPath in
            self?.currentlyApplication = Application(snapshotsDiffFolder: temporaryFolderPath)
        }
    }
}

// MARK: - MenuInteractorInput
extension MenuInteractor: MenuInteractorInput {
    
}
