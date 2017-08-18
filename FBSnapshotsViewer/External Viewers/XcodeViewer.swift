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
        processLauncher.launchProcess(at: "/usr/bin/xcrun", with: ["xed", "-l", String(describing: snapshotTestResult.testLineNumber), snapshotTestResult.testFilePath])
    }
    
    static func isAvailable(osxApplicationFinder: OSXApplicationFinder) -> Bool {
        return osxApplicationFinder.findApplication(with: bundleID) != nil
    }
}
