//
//  SnapshotTestResultSwapperSpec.swift
//  FBSnapshotsViewerTests
//
//  Created by Anton Domashnev on 27.06.17.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Quick
import Nimble

@testable import FBSnapshotsViewer

class SnapshotTestResultSwapper_MockFileManager: FileManager {
    var copyItemCalled: Bool = false
    var copyItemFromSourceURL: URL?
    var copyItemToDestinationURL: URL?
    override func copyItem(at srcURL: URL, to dstURL: URL) throws {
        copyItemCalled = true
        copyItemFromSourceURL = srcURL
        copyItemToDestinationURL = dstURL
    }
    
    var removeItemCalled: Bool = false
    var removeItemAtURL: URL?
    override func removeItem(at URL: URL) throws {
        removeItemCalled = true
        removeItemAtURL = URL
    }
}

class SnapshotTestResultSwapperSpec: QuickSpec {
    override func spec() {
        var build: Build!
        var swapper: SnapshotTestResultSwapper!
        var fileManager: SnapshotTestResultSwapper_MockFileManager!
        
        beforeEach {
            build = Build(date: Date(), applicationName: "MyApp", fbReferenceImageDirectoryURL: URL(fileURLWithPath: "/foo/bar", isDirectory: true))
            fileManager = SnapshotTestResultSwapper_MockFileManager()
            swapper = SnapshotTestResultSwapper(fileManager: fileManager)
        }
        
        describe(".swap") {
            var build: Build!
            var testResult: SnapshotTestResult!
            
            context("given recorded snapshot test result") {
                beforeEach {
                    testResult = SnapshotTestResult.recorded(testName: "Foo", referenceImagePath: "Bar", build: build)
                }
                
                it("throws assertion") {
                    expect{ swapper.swap(testResult) }.to(throwAssertion())
                }
            }
            
            context("given failed snapshot test result") {
                beforeEach {
                    testResult = SnapshotTestResult.failed(testName: "DetailsViewController testNormalState", referenceImagePath: "/Users/antondomashnev/Library/Xcode/tmp/DetailsViewController/reference_testNormalState@2x.png", diffImagePath: "/Users/antondomashnev/Library/Xcode/tmp/DetailsViewController/difftestNormalState@2x.png", failedImagePath: "/Users/antondomashnev/Library/Xcode/tmp/DetailsViewController/failed_testNormalState@2x.png", build: build)
                }
                
                it("removes current reference images from directory") {
                    expect(fileManager.removeItemCalled).to(beTrue())
                    expect(fileManager.removeItemAtURL).to(equal(URL(fileURLWithPath: "/foo/bar/DetailsViewController/testNormalState@2x.png")))
                }
                
                it("copies failed snapshot image to the fb reference images directory") {
                    expect(fileManager.copyItemCalled).to(beTrue())
                    expect(fileManager.copyItemFromSourceURL).to(equal(URL(fileURLWithPath: "/Users/antondomashnev/Library/Xcode/tmp/DetailsViewController/failed_testNormalState@2x.png")))
                    expect(fileManager.copyItemToDestinationURL).to(equal(URL(fileURLWithPath: "/foo/bar/DetailsViewController/testNormalState@2x.png")))
                }
            }
        }
        
        describe(".canSwap") {
            var testResult: SnapshotTestResult!
            
            context("given recorded snapshot test result") {
                beforeEach {
                    testResult = SnapshotTestResult.recorded(testName: "Foo", referenceImagePath: "Bar", build: build)
                }
                
                it("returns false") {
                    expect(swapper.canSwap(testResult)).to(beFalse())
                }
            }
            
            context("given failed snapshot test result") {
                beforeEach {
                    testResult = SnapshotTestResult.failed(testName: "Foo", referenceImagePath: "Reference", diffImagePath: "Diff", failedImagePath: "Failed", build: build)
                }
                
                it("returns true") {
                    expect(swapper.canSwap(testResult)).to(beTrue())
                }
            }
        }
    }
}
