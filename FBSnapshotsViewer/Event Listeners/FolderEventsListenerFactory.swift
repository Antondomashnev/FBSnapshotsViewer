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
             Example of Xcode10 path: .../⁨Logs/Test⁩/FBSnapshotsViewer-2019.03.01_22-42-56-+1300.xcresult⁩/1_Test⁩/⁨Diagnostics⁩/⁨FBSnapshotsViewerExampleTests-D0BABE76-D6E5-4A71-81D9-D98658CA4449⁩/⁨FBSnapshotsViewerExampleTests-C79B8C3C-9B9C-4686-B26B-C7902EC990A2⁩/Session-FBSnapshotsViewerExampleTests-2019-03-01_224259-if2SeO.log
             */
            pathRegex = "/Logs/Test/Test-.+-[0-9]{4}.[0-9]{2}.[0-9]{2}_[0-9]{2}-[0-9]{2}-[0-9]{2}-[+-][0-9]{3,4}.xcresult/[0-1]+_Test/Diagnostics/.+-[0-9a-fA-F]{8}-([0-9a-fA-F]{4}-){3}[0-9a-fA-F]{12}/.+-[0-9a-fA-F]{8}-([0-9a-fA-F]{4}-){3}[0-9a-fA-F]{12}/Session-.+-[0-9]{4}-[0-9]{2}-[0-9]{2}_[0-9]{5,6}-.+.log$"
}
        return NonRecursiveFolderEventsListener(folderPath: derivedDataFolder.path, filter: FolderEventFilter.known & FolderEventFilter.type(.file) & FolderEventFilter.pathRegex(pathRegex))
    }
}
