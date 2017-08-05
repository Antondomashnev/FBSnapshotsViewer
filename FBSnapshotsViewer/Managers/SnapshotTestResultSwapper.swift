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
    case notExistedRecordedImage(testResult: SnapshotTestResult)
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
    
    private func buildRecordedImageURL(from imagePath: String, of testResult: SnapshotTestResult) throws -> URL {
        guard let failedImageSizeSuffixRange = imagePath.range(of: "@\\d{1}x", options: .regularExpression) else {
                throw SnapshotTestResultSwapperError.nonRetinaImages(testResult: testResult)
        }
        let failedImageSizeSuffix = imagePath.substring(with: failedImageSizeSuffixRange)
        let recordedImageURLs = testResult.build.fbReferenceImageDirectoryURLs.flatMap { fbReferenceImageDirectoryURL -> URL? in
            let url = fbReferenceImageDirectoryURL.appendingPathComponent(testResult.testClassName).appendingPathComponent("\(testResult.testName)\(failedImageSizeSuffix)").appendingPathExtension("png")
            return fileManager.fileExists(atPath: url.path) ? url : nil
        }
        guard let url = recordedImageURLs.first else {
            throw SnapshotTestResultSwapperError.notExistedRecordedImage(testResult: testResult)
        }
        return url
    }
    
    // MARK: - Interface
    
    func canSwap(_ testResult: SnapshotTestResult) -> Bool {
        if case SnapshotTestResult.failed(_, _, _, _, _) = testResult {
            return true
        }
        return false
    }
    
    func swap(_ testResult: SnapshotTestResult) throws -> SnapshotTestResult {
        guard case let SnapshotTestResult.failed(testInformation, _, _, failedImagePath, build) = testResult, canSwap(testResult) else {
            throw SnapshotTestResultSwapperError.canNotBeSwapped(testResult: testResult)
        }
        let failedImageURL = URL(fileURLWithPath: failedImagePath, isDirectory: false)
        do {
            let recordedImageURL = try buildRecordedImageURL(from: failedImagePath, of: testResult)
            try fileManager.moveItem(at: failedImageURL, to: recordedImageURL)
            imageCache.invalidate()
            return SnapshotTestResult.recorded(testInformation: testInformation, referenceImagePath: recordedImageURL.path, build: build)
        }
        catch let error {
            throw SnapshotTestResultSwapperError.canNotPerformFileManagerOperation(testResult: testResult, underlyingError: error)
        }
    }
}
