//
//  TestResult.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 05/02/2017.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Cocoa

/// `TestResult` enum represents the FBSnapshotTestCase result
///
/// - record: represents the `recordMode == YES` result of new reference image
/// - failed: represents the real test case result in case of failure
enum TestResult {
    case record(referenceImageAt: URL)
    case failed(referenceImageAt: URL, failedImageAt: URL)
}
