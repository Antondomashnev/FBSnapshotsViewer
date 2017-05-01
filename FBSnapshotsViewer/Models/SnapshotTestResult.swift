//
//  SnapshotTestResult.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 05/02/2017.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Cocoa

enum SnapshotTestResult: AutoEquatable {
    case recorded(testName: String, referenceImagePath: String)
    case failed(testName: String, referenceImagePath: String, diffImagePath: String, failedImagePath: String)
}
