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
    enum SnapshotTestResultSwapper_MockFileManagerError: Error {
        case sample
    }
    
    var copyItemCalled: Bool = false
    var copyItemFromSourceURL: URL?
    var copyItemToDestinationURL: URL?
    var copyItemThrows: Bool = false
    override func copyItem(at srcURL: URL, to dstURL: URL) throws {
        if copyItemThrows {
            throw SnapshotTestResultSwapper_MockFileManagerError.sample
        }
        copyItemCalled = true
        copyItemFromSourceURL = srcURL
        copyItemToDestinationURL = dstURL
    }
    
    var removeItemCalled: Bool = false
    var removeItemAtURL: URL?
    var removeItemThrows: Bool = false
    override func removeItem(at URL: URL) throws {
        if removeItemThrows {
            throw SnapshotTestResultSwapper_MockFileManagerError.sample
        }
        removeItemCalled = true
        removeItemAtURL = URL
    }
}

class SnapshotTestResultSwapperSpec: QuickSpec {
    override func spec() {
        var build: Build!
        var imageCache: ImageCacheMock!
        var swapper: SnapshotTestResultSwapper!
        var fileManager: SnapshotTestResultSwapper_MockFileManager!
        
        beforeEach {
            build = Build(date: Date(), applicationName: "MyApp", fbReferenceImageDirectoryURL: URL(fileURLWithPath: "/foo/bar", isDirectory: true))
            fileManager = SnapshotTestResultSwapper_MockFileManager()
            imageCache = ImageCacheMock()
            swapper = SnapshotTestResultSwapper(fileManager: fileManager, imageCache: imageCache)
        }
        
        describe(".swap") {
            var testResult: SnapshotTestResult!
            
            context("given recorded snapshot test result") {
                beforeEach {
                    testResult = SnapshotTestResult.recorded(testInformation: SnapshotTestInformation(testClassName: "Bar", testName: "Foo"), referenceImagePath: "Bar", build: build)
                }
                
                it("throws error") {
                    expect { try swapper.swap(testResult) }.to(throwError())
                }
            }
            
            context("when file manager throws exception") {
                beforeEach {
                    testResult = SnapshotTestResult.failed(testInformation: SnapshotTestInformation(testClassName: "DetailsViewController", testName: "testNormalState"), referenceImagePath: "/Users/antondomashnev/Library/Xcode/tmp/DetailsViewController/reference_testNormalState@2x.png", diffImagePath: "/Users/antondomashnev/Library/Xcode/tmp/DetailsViewController/difftestNormalState@2x.png", failedImagePath: "/Users/antondomashnev/Library/Xcode/tmp/DetailsViewController/failed_testNormalState@2x.png", build: build)
                    fileManager.removeItemThrows = true
                }
                
                it("throws error") {
                    expect { try swapper.swap(testResult) }.to(throwError())
                }
            }
            
            context("given failed snapshot test result") {
                context("with non-retina images") {
                    beforeEach {
                        testResult = SnapshotTestResult.failed(testInformation: SnapshotTestInformation(testClassName: "DetailsViewController", testName: "testNormalState"), referenceImagePath: "/Users/antondomashnev/Library/Xcode/tmp/DetailsViewController/reference_testNormalState.png", diffImagePath: "/Users/antondomashnev/Library/Xcode/tmp/DetailsViewController/difftestNormalState@.png", failedImagePath: "/Users/antondomashnev/Library/Xcode/tmp/DetailsViewController/failed_testNormalState@.png", build: build)
                    }
                    
                    it("throws error") {
                        expect { try swapper.swap(testResult) }.to(throwError())
                    }
                }
                
                context("with retina images") {
                    var returnedTestResult: SnapshotTestResult!
                    
                    beforeEach {
                        testResult = SnapshotTestResult.failed(testInformation: SnapshotTestInformation(testClassName: "DetailsViewController", testName: "testNormalState"), referenceImagePath: "/Users/antondomashnev/Library/Xcode/tmp/DetailsViewController/reference_testNormalState@2x.png", diffImagePath: "/Users/antondomashnev/Library/Xcode/tmp/DetailsViewController/difftestNormalState@2x.png", failedImagePath: "/Users/antondomashnev/Library/Xcode/tmp/DetailsViewController/failed_testNormalState@2x.png", build: build)
                         returnedTestResult = try? swapper.swap(testResult)
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
                    
                    it("invalidates cache") {
                        expect(imageCache.invalidate_Called).to(beTrue())
                    }
                    
                    it("returns swapped test result") {
                        let expectedTestResult = SnapshotTestResult.recorded(testInformation: SnapshotTestInformation(testClassName: "DetailsViewController", testName: "testNormalState"), referenceImagePath: "/foo/bar/DetailsViewController/testNormalState@2x.png", build: build)
                        expect(returnedTestResult).to(equal(expectedTestResult))
                    }
                }
            }
        }
        
        describe(".canSwap") {
            var testResult: SnapshotTestResult!
            
            context("given recorded snapshot test result") {
                beforeEach {
                    testResult = SnapshotTestResult.recorded(testInformation: SnapshotTestInformation(testClassName: "Bar", testName: "Foo"), referenceImagePath: "Bar", build: build)
                }
                
                it("returns false") {
                    expect(swapper.canSwap(testResult)).to(beFalse())
                }
            }
            
            context("given failed snapshot test result") {
                beforeEach {
                    testResult = SnapshotTestResult.failed(testInformation: SnapshotTestInformation(testClassName: "Bar", testName: "Foo"), referenceImagePath: "Reference", diffImagePath: "Diff", failedImagePath: "Failed", build: build)
                }
                
                it("returns true") {
                    expect(swapper.canSwap(testResult)).to(beTrue())
                }
            }
        }
    }
}
