//
//  ExternalViewer.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 05.05.17.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Foundation

struct ExternalViewers {
    let xcode: ExternalViewer.Type
    let kaleidoscope: ExternalViewer.Type
    
    init(xcodeViewer: ExternalViewer.Type = XcodeViewer.self, kaleidoscopeViewer: ExternalViewer.Type = KaleidoscopeViewer.self) {
        self.xcode = xcodeViewer
        self.kaleidoscope = kaleidoscopeViewer
    }
}

protocol ExternalViewer {
    static var name: String { get }
    static var bundleID: String { get }

    static func isAvailable(osxApplicationFinder: OSXApplicationFinder) -> Bool
    static func canView(snapshotTestResult: SnapshotTestResult) -> Bool
    static func view(snapshotTestResult: SnapshotTestResult, using processLauncher: ProcessLauncher)
}

extension ExternalViewer {
    static func isAvailable(osxApplicationFinder: OSXApplicationFinder = OSXApplicationFinder()) -> Bool {
        return isAvailable(osxApplicationFinder: osxApplicationFinder)
    }
}
