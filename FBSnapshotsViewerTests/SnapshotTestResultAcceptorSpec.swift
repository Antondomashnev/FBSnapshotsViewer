//
//  SnapshotTestResultAcceptorSpec.swift
//  FBSnapshotsViewerTests
//
//  Created by Anton Domashnev on 27.06.17.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Quick
import Nimble

@testable import FBSnapshotsViewer

class SnapshotTestResultAcceptor_MockFileManager: FileManager {
    enum SnapshotTestResultAcceptor_MockFileManagerError: Error {
        case sample
    }
    
    var copyItemCalled: Bool = false
    var copyItemFromSourceURL: URL?
    var copyItemToDestinationURL: URL?
    var copyItemThrows: Bool = false
    override func copyItem(at srcURL: URL, to dstURL: URL) throws {
        if copyItemThrows {
            throw SnapshotTestResultAcceptor_MockFileManagerError.sample
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
            throw SnapshotTestResultAcceptor_MockFileManagerError.sample
        }
        removeItemCalled = true
        removeItemAtURL = URL
    }
    
    var fileExistsCalled: Bool = false
    var fileExistsReturnValue: Bool = false
    override func fileExists(atPath path: String) -> Bool {
        fileExistsCalled = true
        return fileExistsReturnValue
    }
}

class SnapshotTestResultAcceptorSpec: QuickSpec {
    override func spec() {
        var build: Build!
        var testInformation: SnapshotTestInformation!
        var imageCache: ImageCacheMock!
        var acceptor: SnapshotTestResultAcceptor!
        var fileManager: SnapshotTestResultAcceptor_MockFileManager!
        
        beforeEach {
            build = Build(date: Date(), applicationName: "MyApp", fbReferenceImageDirectoryURLs: [URL(fileURLWithPath: "/foo/bar", isDirectory: true)])
            testInformation = SnapshotTestInformation(testClassName: "Bar", testName: "Foo", testFilePath: "Bar/Foo.m", testLineNumber: 1)
            fileManager = SnapshotTestResultAcceptor_MockFileManager()
            imageCache = ImageCacheMock()
            acceptor = SnapshotTestResultAcceptor(fileManager: fileManager, imageCache: imageCache)
        }
        
        describe(".accept") {
            var testResult: SnapshotTestResult!
            
            context("given recorded snapshot test result") {
                beforeEach {
                    testResult = SnapshotTestResult.recorded(testInformation: testInformation, referenceImagePath: "Bar", build: build)
                }
                
                it("throws error") {
                    expect { try acceptor.accept(testResult) }.to(throwError())
                }
            }
            
            context("when file manager throws exception") {
                beforeEach {
                    testInformation = SnapshotTestInformation(testClassName: "DetailsViewController", testName: "testNormalState", testFilePath: "foo/DetailsViewController.m", testLineNumber: 1)
                    testResult = SnapshotTestResult.failed(testInformation: testInformation, referenceImagePath: "/Users/antondomashnev/Library/Xcode/tmp/DetailsViewController/reference_testNormalState@2x.png", diffImagePath: "/Users/antondomashnev/Library/Xcode/tmp/DetailsViewController/difftestNormalState@2x.png", failedImagePath: "/Users/antondomashnev/Library/Xcode/tmp/DetailsViewController/failed_testNormalState@2x.png", build: build)
                    fileManager.removeItemThrows = true
                }
                
                it("throws error") {
                    expect { try acceptor.accept(testResult) }.to(throwError())
                }
            }
            
            context("given failed snapshot test result") {
                context("with non-retina images") {
                    beforeEach {
                        testInformation = SnapshotTestInformation(testClassName: "DetailsViewController", testName: "testNormalState", testFilePath: "foo/DetailsViewController.m", testLineNumber: 1)
                        testResult = SnapshotTestResult.failed(testInformation: testInformation, referenceImagePath: "/Users/antondomashnev/Library/Xcode/tmp/DetailsViewController/reference_testNormalState.png", diffImagePath: "/Users/antondomashnev/Library/Xcode/tmp/DetailsViewController/difftestNormalState@.png", failedImagePath: "/Users/antondomashnev/Library/Xcode/tmp/DetailsViewController/failed_testNormalState@.png", build: build)
                    }
                    
                    it("throws error") {
                        expect { try acceptor.accept(testResult) }.to(throwError())
                    }
                }
                
                context("with retina images") {
                    var returnedTestResult: SnapshotTestResult!
                    
                    beforeEach {
                        testInformation = SnapshotTestInformation(testClassName: "DetailsViewController", testName: "testNormalState", testFilePath: "foo/DetailsViewController.m", testLineNumber: 1)
                        testResult = SnapshotTestResult.failed(testInformation: testInformation, referenceImagePath: "/Users/antondomashnev/Library/Xcode/tmp/DetailsViewController/reference_testNormalState@2x.png", diffImagePath: "/Users/antondomashnev/Library/Xcode/tmp/DetailsViewController/difftestNormalState@2x.png", failedImagePath: "/Users/antondomashnev/Library/Xcode/tmp/DetailsViewController/failed_testNormalState@2x.png", build: build)
                    }
                    
                    context("that doesn't exist") {
                        beforeEach {
                            fileManager.fileExistsReturnValue = false
                        }
                        
                        it("throws error") {
                            expect { try acceptor.accept(testResult) }.to(throwError())
                        }
                    }
                    
                    context("that exists") {
                        beforeEach {
                            fileManager.fileExistsReturnValue = true
                            returnedTestResult = try? acceptor.accept(testResult)
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
                        
                        it("returns accepted test result") {
                            let expectedTestInformation = SnapshotTestInformation(testClassName: "DetailsViewController", testName: "testNormalState", testFilePath: "foo/DetailsViewController.m", testLineNumber: 1)
                            let expectedTestResult = SnapshotTestResult.recorded(testInformation: expectedTestInformation, referenceImagePath: "/foo/bar/DetailsViewController/testNormalState@2x.png", build: build)
                            expect(returnedTestResult).to(equal(expectedTestResult))
                        }
                    }
                }
            }
        }
        
        describe(".canAccept") {
            var testResult: SnapshotTestResult!
            
            context("given recorded snapshot test result") {
                beforeEach {
                    testResult = SnapshotTestResult.recorded(testInformation: testInformation, referenceImagePath: "Bar", build: build)
                }
                
                it("returns false") {
                    expect(acceptor.canAccept(testResult)).to(beFalse())
                }
            }
            
            context("given failed snapshot test result") {
                beforeEach {
                    testResult = SnapshotTestResult.failed(testInformation: testInformation, referenceImagePath: "Reference", diffImagePath: "Diff", failedImagePath: "Failed", build: build)
                }
                
                it("returns true") {
                    expect(acceptor.canAccept(testResult)).to(beTrue())
                }
            }
        }
    }
}
