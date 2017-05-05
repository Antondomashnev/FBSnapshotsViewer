//
//  KaleidoscopeViewer.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 05.05.17.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Foundation

/// Represents the Kaleidoscope app
class KaleidoscopeViewer: ExternalViewer {

    // MARK: - ExternalViewer

    static var name: String {
        return "Kaleidoscope"
    }

    static var bundleID: String {
        return "com.blackpixel.kaleidoscope"
    }

    static func canView(snapshotTestResult: SnapshotTestResult) -> Bool {
        if case SnapshotTestResult.failed(_, _, _, _) = snapshotTestResult {
            return true
        }
        return false
    }

    static func view(snapshotTestResult: SnapshotTestResult, using processLauncher: ProcessLauncher = ProcessLauncher()) {
        guard case let SnapshotTestResult.failed(_, referenceImagePath, _, failedImagePath) = snapshotTestResult else {
            assertionFailure("Trying to open Kaleidoscope viewer for test result without diff")
            return
        }
        processLauncher.launchProcess(at: "/usr/local/bin/ksdiff", with: [referenceImagePath, failedImagePath])
    }
}
