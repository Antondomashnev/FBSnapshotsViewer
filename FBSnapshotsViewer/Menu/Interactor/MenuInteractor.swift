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
    
    /// Snapshots diff folder listener. Nil when snapshots diff folder is unknown.
    /// Basically it means that the `snaphotsDiffFolderNotificationListener` has not received notification yet
    fileprivate var currentSnapshotsDiffFolderListener: FolderEventsListener?
    
    init(snaphotsDiffFolderNotificationListener: SnapshotsDiffFolderNotificationListener) {
        self.snaphotsDiffFolderNotificationListener = snaphotsDiffFolderNotificationListener
    }
}

// MARK: - SnapshotsDiffFolderNotificationListenerDelegate
extension MenuInteractor: SnapshotsDiffFolderNotificationListenerDelegate {
    func snapshotsDiffFolderNotificationListener(_ listener: SnapshotsDiffFolderNotificationListener, didReceive folderPath: String) {
        
    }
}
