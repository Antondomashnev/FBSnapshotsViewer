//
//  FolderEventsListenerFactory.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 11/02/2017.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Foundation

class FolderEventsListenerFactory {
    // MARK: - Interface
    
    func snapshotsDiffFolderEventsListener(at folderPath: String) -> FolderEventsListener {
        return RecursiveFolderEventsListener(folderPath: folderPath, filter: FolderEventFilter.known)
    }
    
    func iOSSimulatorFolderEventsListener(at simulatorPath: String) -> FolderEventsListener {
        return RecursiveFolderEventsListener(folderPath: simulatorPath, filter: FolderEventFilter.known)
    }
}
