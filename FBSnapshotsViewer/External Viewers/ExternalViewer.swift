//
//  ExternalViewer.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 05.05.17.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Foundation

protocol ExternalViewer {
    static var name: String { get }
    static var bundleID: String { get }

    static func isAvailable(osxApplicationFinder: OSXApplicationFinder) -> Bool
    static func view(snapshotTestResult: SnapshotTestResult, using processLauncher: ProcessLauncher)
}

extension ExternalViewer {
    static func isAvailable(osxApplicationFinder: OSXApplicationFinder = OSXApplicationFinder()) -> Bool {
        return osxApplicationFinder.findApplication(with: bundleID) != nil
    }
}
