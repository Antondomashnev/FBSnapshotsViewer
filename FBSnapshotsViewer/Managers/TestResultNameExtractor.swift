//
//  TestResultNameExtractor.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 26/02/2017.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Foundation

class TestResultNameExtractor {
    static let diffImagePrefix = "diff_"
    static let referenceImagePrefix = "reference_"
    static let failedImagePrefix = "failed_"

    /// Since the image name is expected to be something like
    /// .../E78B5865-234B-4779-BCED-784C91146583/tmp/FBSnapshotsViewerExampleTests/failed_testExample@2x.png"
    /// To extract test name it requires to remove @2x.png suffix which can be either '@2x.png' or '@3x.png'
    static let imageSuffixLength = 7
    
    static func extractTestName(from imagePath: String) -> String? {
        for prefix in [diffImagePrefix, referenceImagePrefix, failedImagePrefix] {
            guard let lastComponentPath = imagePath.components(separatedBy: "/").last else {
                continue
            }
            guard lastComponentPath.hasPrefix(prefix) else {
                continue
            }
            let start = lastComponentPath.index(lastComponentPath.startIndex, offsetBy: prefix.characters.count)
            let end = lastComponentPath.index(lastComponentPath.endIndex, offsetBy: -imageSuffixLength)
            let testName = lastComponentPath.substring(with: start..<end)
            return testName
        }
        return nil
    }
}
