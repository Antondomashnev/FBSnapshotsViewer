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
        let pathRegex: String
        if derivedDataFolder.type == .appcode {
            pathRegex = "/testHistory/[0-9a-fA-F]+/.+ - [0-9]{4}.[0-9]{2}.[0-9]{2} at [0-9]{2}h [0-9]{2}m [0-9]{2}s.xml$"
        }
        else {
            /*
             Example of Xcode8 path: .../Logs/Test/FFCD258F-DE70-4B03-A32D-3065E248C0A7/Session-FBSnapshotsViewerExampleTests-2017-08-01_225044-7QQdug.log
             Example of Xcode9 path: .../Logs/Test/Diagnostics/FBSnapshotsViewerExampleTests-7BBCF944-204D-4F76-8491-D6E8392F1E98/Session-FBSnapshotsViewerExampleTests-2017-08-01_223254-O0ChTG.log
             */
            pathRegex = "/Logs/Test(/Diagnostics/.+-[0-9a-fA-F]{8}-([0-9a-fA-F]{4}-){3}[0-9a-fA-F]{12}|/[0-9a-fA-F]{8}-([0-9a-fA-F]{4}-){3}[0-9a-fA-F]{12})/.+log$"
        }
        return NonRecursiveFolderEventsListener(folderPath: derivedDataFolder.path, filter: FolderEventFilter.known & FolderEventFilter.type(.file) & FolderEventFilter.pathRegex(pathRegex))
    }
}
