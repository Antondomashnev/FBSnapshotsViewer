//
//  MenuInteractor.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 05/02/2017.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Foundation

class MenuInteractor {
    /// Instance of listener for snapshots diff folder notification
    private let snaphotsDiffFolderNotificationListener: SnapshotsViewerApplicationRunNotificationListener
    
    /// Instance of folder events listener factory to get listeners from
    fileprivate let folderEventsListenerFactory: FolderEventsListenerFactory
    
    /// Snapshots diff folder listener. Nil when snapshots diff folder is unknown.
    /// Basically it means that the `snaphotsDiffFolderNotificationListener` has not received notification yet
    fileprivate var currentSnapshotsDiffFolderListener: FolderEventsListener?
    
    init(snaphotsDiffFolderNotificationListener: SnapshotsViewerApplicationRunNotificationListener, folderEventsListenerFactory: FolderEventsListenerFactory) {
        self.folderEventsListenerFactory = folderEventsListenerFactory
        self.snaphotsDiffFolderNotificationListener = snaphotsDiffFolderNotificationListener
        self.snaphotsDiffFolderNotificationListener.delegate = self
    }
}

// MARK: - SnapshotsViewerApplicationRunNotificationListenerDelegate
extension MenuInteractor: SnapshotsViewerApplicationRunNotificationListenerDelegate {
    func snapshotsDiffFolderNotificationListener(_ listener: SnapshotsViewerApplicationRunNotificationListener, didReceiveRunningiOSSimulatorFolder simulatorPath: String, andImageDiffFolder imageDiffPath: String?) {
        currentSnapshotsDiffFolderListener = folderEventsListenerFactory.snapshotsDiffFolderEventsListener(at: simulatorPath)
        currentSnapshotsDiffFolderListener?.output = self
        currentSnapshotsDiffFolderListener?.startListening()
    }
}

// MARK: - FolderEventsListenerOutput
extension MenuInteractor: FolderEventsListenerOutput {
    func folderEventsListener(_ listener: FolderEventsListener, didReceive events: [FolderEvent]) {
        let knownEvents = events.filter { event in
            switch event {
            case .unknown: return false
            default: return true
            }
        }
        if knownEvents.isEmpty {
            return
        }
        print("Received new events: \(knownEvents)")
    }
}

// MARK: - MenuInteractorInput
extension MenuInteractor: MenuInteractorInput {
    
}
