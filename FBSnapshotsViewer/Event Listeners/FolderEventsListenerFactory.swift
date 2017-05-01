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
        return RecursiveFolderEventsListener(folderPath: folderPath, filter: FolderEventFilter.known & FolderEventFilter.type(.file) & FolderEventFilter.pathRegex("(diff|reference|failed)_.+\\.png$"))
    }

    func iOSSimulatorApplicationsFolderEventsListener(at simulatorPath: String) -> FolderEventsListener {
        return NonRecursiveFolderEventsListener(folderPath: simulatorPath, filter: FolderEventFilter.known & FolderEventFilter.type(.folder))
    }

    func applicationTestLogsEventsListener(at xcodeDerivedDataFolderPath: String) -> FolderEventsListener {
        return NonRecursiveFolderEventsListener(folderPath: xcodeDerivedDataFolderPath, filter: FolderEventFilter.known & FolderEventFilter.type(.file) & FolderEventFilter.pathRegex("/Logs/Test/[0-9a-fA-F]{8}-([0-9a-fA-F]{4}-){3}[0-9a-fA-F]{12}/.+log$"))
    }
}
