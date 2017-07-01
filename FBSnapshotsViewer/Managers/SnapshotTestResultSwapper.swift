//
//  SnapshotTestResultSwapper.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 27.06.17.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Foundation
import Nuke

enum SnapshotTestResultSwapperError: Error {
    case canNotBeSwapped(testResult: SnapshotTestResult)
    case nonRetinaImages(testResult: SnapshotTestResult)
    case canNotPerformFileManagerOperation(testResult: SnapshotTestResult, underlyingError: Error)
}

class SnapshotTestResultSwapper {
    private let fileManager: FileManager
    private let imageCache: ImageCache
    
    init(fileManager: FileManager = FileManager.default, imageCache: ImageCache = Nuke.Cache.shared) {
        self.imageCache = imageCache
        self.fileManager = fileManager
    }
    
    // MARK: - Helpers
    
    private  func extractImageSuffix(from imagePath: String, of testResult: SnapshotTestResult) throws -> String {
        guard let failedImageSizeSuffixRange = imagePath.range(of: "@\\d{1}x", options: .regularExpression) else {
                throw SnapshotTestResultSwapperError.nonRetinaImages(testResult: testResult)
        }
        return imagePath.substring(with: failedImageSizeSuffixRange)
    }
    
    // MARK: - Interface
    
    func canSwap(_ testResult: SnapshotTestResult) -> Bool {
        if case SnapshotTestResult.failed(_, _, _, _, _) = testResult {
            return true
        }
        return false
    }
    
    func swap(_ testResult: SnapshotTestResult) throws {
        guard case let SnapshotTestResult.failed(testInformation, _, _, failedImagePath, build) = testResult, canSwap(testResult) else {
            throw SnapshotTestResultSwapperError.canNotBeSwapped(testResult: testResult)
        }
        let failedImageSizeSuffix = try extractImageSuffix(from: failedImagePath, of: testResult)
        let recordedImageURL = build.fbReferenceImageDirectoryURL.appendingPathComponent(testInformation.testClassName).appendingPathComponent("\(testInformation.testName)\(failedImageSizeSuffix)").appendingPathExtension("png")
        let failedImageURL = URL(fileURLWithPath: failedImagePath, isDirectory: false)
        do {
            try fileManager.removeItem(at: recordedImageURL)
            try fileManager.copyItem(at: failedImageURL, to: recordedImageURL)
            imageCache.invalidate()
        }
        catch let error {
            throw SnapshotTestResultSwapperError.canNotPerformFileManagerOperation(testResult: testResult, underlyingError: error)
        }
    }
}
