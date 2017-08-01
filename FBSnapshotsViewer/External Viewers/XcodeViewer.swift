//
//  XcodeViewer.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 01.08.17.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Foundation

/// Represents the Xcode app
class XcodeViewer: ExternalViewer {
    // MARK: - ExternalViewer
    
    static var name: String {
        return "Xcode"
    }
    
    static var bundleID: String {
        return "com.apple.dt.Xcode"
    }
    
    static func canView(snapshotTestResult: SnapshotTestResult) -> Bool {
        return true
    }
    
    static func view(snapshotTestResult: SnapshotTestResult, using processLauncher: ProcessLauncher = ProcessLauncher()) {
        guard case let SnapshotTestResult.failed(_, referenceImagePath, _, failedImagePath, _) = snapshotTestResult else {
            assertionFailure("Trying to open Kaleidoscope viewer for test result without diff")
            return
        }
        processLauncher.launchProcess(at: "/usr/local/bin/ksdiff", with: [referenceImagePath, failedImagePath])
    }
    
    static func isAvailable(osxApplicationFinder: OSXApplicationFinder) -> Bool {
        return osxApplicationFinder.findApplication(with: bundleID) != nil
    }
}
