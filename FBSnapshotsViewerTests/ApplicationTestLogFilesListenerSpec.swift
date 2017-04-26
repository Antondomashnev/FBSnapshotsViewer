//
//  ApplicationTestLogFilesListenerSpec.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 26.04.17.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Quick
import Nimble

@testable import FBSnapshotsViewer

class ApplicationTestLogFilesListener_MockFolderEventsListenerFactory: FolderEventsListenerFactory {
    override func applicationTestLogsEventsListener(at xcodeDerivedDataFolderPath: String) -> FolderEventsListener {

    }
}

class ApplicationTestLogFilesListenerSpec: QuickSpec {
    override func spec() {
        var applicationTestLogFilesListener: ApplicationTestLogFilesListener!

        beforeEach {
            applicationTestLogFilesListener = ApplicationTestLogFilesListener(folderEventsListenerFactory: FolderEventsListenerFactory)
        }
    }
}
