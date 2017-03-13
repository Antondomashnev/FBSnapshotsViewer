//
//  SnapshotTestImage.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 26/02/2017.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Foundation

enum SnapshotTestImage {
    private static let diffImagePrefix = "diff_"
    private static let referenceImagePrefix = "reference_"
    private static let failedImagePrefix = "failed_"

    /// Since the image name is expected to be something like
    /// .../E78B5865-234B-4779-BCED-784C91146583/tmp/FBSnapshotsViewerExampleTests/failed_testExample@2x.png"
    /// To extract test name it requires to remove @2x.png suffix
    private static let testImageSuffix = "@2x.png"

    case diff(imagePath: String)
    case reference(imagePath: String)
    case failed(imagePath: String)

    init?(imagePath: String) {
        guard let lastComponentPath = imagePath.components(separatedBy: "/").last else {
            return nil
        }
        if lastComponentPath.hasPrefix(SnapshotTestImage.diffImagePrefix) {
            self = .diff(imagePath: imagePath)
        }
        else if lastComponentPath.hasPrefix(SnapshotTestImage.referenceImagePrefix) {
            self = .reference(imagePath: imagePath)
        }
        else if lastComponentPath.hasPrefix(SnapshotTestImage.failedImagePrefix) {
            self = .failed(imagePath: imagePath)
        }
        else {
            return nil
        }
    }

    // MARK: - Interface

    var testName: String {
        func extractTestName(from path: String, pathPrefix: String, pathSuffix: String) -> String {
            guard let lastComponentPath = path.components(separatedBy: "/").last else {
                assertionFailure("All of possbile SnapshotTestImage must have lastComponentPath")
                return ""
            }
            let start = lastComponentPath.index(lastComponentPath.startIndex, offsetBy: pathPrefix.characters.count)
            let end = lastComponentPath.index(lastComponentPath.endIndex, offsetBy: -pathSuffix.characters.count)
            let testName = lastComponentPath.substring(with: start..<end)
            return testName
        }
        switch self {
        case let .diff(imagePath: imagePath):
            return extractTestName(from: imagePath, pathPrefix: SnapshotTestImage.diffImagePrefix, pathSuffix: SnapshotTestImage.testImageSuffix)
        case let .reference(imagePath: imagePath):
            return extractTestName(from: imagePath, pathPrefix: SnapshotTestImage.referenceImagePrefix, pathSuffix: SnapshotTestImage.testImageSuffix)
        case let .failed(imagePath: imagePath):
            return extractTestName(from: imagePath, pathPrefix: SnapshotTestImage.failedImagePrefix, pathSuffix: SnapshotTestImage.testImageSuffix)
        }
    }
}

/// Equatable
extension SnapshotTestImage: AutoEquatable {}
