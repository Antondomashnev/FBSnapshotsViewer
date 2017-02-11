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
    private let snaphotsDiffFolderNotificationListener: SnapshotsDiffFolderNotificationListener
    
    /// Instance of folder events listener factory to get listeners from
    fileprivate let folderEventsListenerFactory: FolderEventsListenerFactory
    
    /// Snapshots diff folder listener. Nil when snapshots diff folder is unknown.
    /// Basically it means that the `snaphotsDiffFolderNotificationListener` has not received notification yet
    fileprivate var currentSnapshotsDiffFolderListener: FolderEventsListener?
    
    init(snaphotsDiffFolderNotificationListener: SnapshotsDiffFolderNotificationListener, folderEventsListenerFactory: FolderEventsListenerFactory) {
        self.folderEventsListenerFactory = folderEventsListenerFactory
        self.snaphotsDiffFolderNotificationListener = snaphotsDiffFolderNotificationListener
        self.snaphotsDiffFolderNotificationListener.delegate = self
    }
}

// MARK: - SnapshotsDiffFolderNotificationListenerDelegate
extension MenuInteractor: SnapshotsDiffFolderNotificationListenerDelegate {
    func snapshotsDiffFolderNotificationListener(_ listener: SnapshotsDiffFolderNotificationListener, didReceive folderPath: String) {
        currentSnapshotsDiffFolderListener = folderEventsListenerFactory.snapshotsDiffFolderEventsListener(at: folderPath)
        currentSnapshotsDiffFolderListener?.output = self
        currentSnapshotsDiffFolderListener?.startListening()
    }
}

// MARK: - FolderEventsListenerOutput
extension MenuInteractor: FolderEventsListenerOutput {
    func folderEventsListener(_ listener: FolderEventsListener, didReceive events: [FolderEvent]) {
        print("Received new events: \(events)")
    }
}

// MARK: - MenuInteractorInput
extension MenuInteractor: MenuInteractorInput {
    
}
