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

    func iOSSimulatorApplicationsFolderEventsListener(at simulatorPath: String) -> FolderEventsListener {
        return NonRecursiveFolderEventsListener(folderPath: simulatorPath, filter: FolderEventFilter.known & FolderEventFilter.type(.folder))
    }

    func applicationTestLogsEventsListener(at derivedDataFolder: DerivedDataFolder) -> FolderEventsListener {
        let pathRegex = derivedDataFolder.type == .appcode ? "/testHistory/[0-9a-fA-F]+/.+ - [0-9]{4}.[0-9]{2}.[0-9]{2} at [0-9]{2}h [0-9]{2}m [0-9]{2}s.xml$" : "/Logs/Test/[0-9a-fA-F]{8}-([0-9a-fA-F]{4}-){3}[0-9a-fA-F]{12}/.+log$"
        return NonRecursiveFolderEventsListener(folderPath: derivedDataFolder.path, filter: FolderEventFilter.known & FolderEventFilter.type(.file) & FolderEventFilter.pathRegex(pathRegex))
    }
}
