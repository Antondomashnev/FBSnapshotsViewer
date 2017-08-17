//
//  XcodeViewerSpec.swift
//  FBSnapshotsViewerTests
//
//  Created by Anton Domashnev on 17.08.17.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Quick
import Nimble

@testable import FBSnapshotsViewer

private class ProcessLauncherMock: ProcessLauncher {
    var launchedProcessPath: String?
    var launchedProcessArguments: [String]?
    
    override func launchProcess(at launchPath: String, with arguments: [String]?) {
        launchedProcessPath = launchPath
        launchedProcessArguments = arguments
    }
}

private class OSXApplicationFinderMock: OSXApplicationFinder {
    var applicationURL: URL?
    
    override func findApplication(with bundleIdentifier: String) -> URL? {
        return applicationURL
    }
}

class XcodeViewerSpec: QuickSpec {
    override func spec() {
        let subject: XcodeViewer.Type = XcodeViewer.self
        var processLauncher: ProcessLauncherMock!
        var osxApplicationFinder: OSXApplicationFinderMock!
        
        beforeEach {
            processLauncher = ProcessLauncherMock()
            osxApplicationFinder = OSXApplicationFinderMock()
        }
        
        describe("name") {
            it("is Xcode") {
                expect(subject.name).to(equal("Xcode"))
            }
        }
        
        describe("bundleID") {
            it("is correct") {
                expect(subject.bundleID).to(equal("com.apple.dt.Xcode"))
            }
        }
        
        describe(".canView") {
            var testResult: SnapshotTestResult!
            var build: Build!
            var testInformation: SnapshotTestInformation!
            
            beforeEach {
                build = Build(date: Date(), applicationName: "MyApp", fbReferenceImageDirectoryURLs: [URL(fileURLWithPath: "foo/bar", isDirectory: true)])
                testInformation = SnapshotTestInformation(testClassName: "ExampleTestClass", testName: "testName", testFilePath: "testFilePath", testLineNumber: 1)
            }
            
            context("for recorded snapshot test result") {
                beforeEach {
                    testResult = SnapshotTestResult.recorded(testInformation: testInformation, referenceImagePath: "foo/bar/referenceImage.png", build: build)
                }
                
                it("returns true") {
                    expect(subject.canView(snapshotTestResult: testResult)).to(beTrue())
                }
            }
            
            context("for failed snapshot test result") {
                beforeEach {
                    testResult = SnapshotTestResult.failed(testInformation: testInformation, referenceImagePath: "foo/bar/referenceImage.png", diffImagePath: "foo/bar/diffImage.png", failedImagePath: "foo/bar/failedImage.png", build: build)
                }
                
                it("returns true") {
                    expect(subject.canView(snapshotTestResult: testResult)).to(beTrue())
                }
            }
        }
        
        describe(".isAvailable") {
            context("when application finder finds the app with bundleID") {
                beforeEach {
                    osxApplicationFinder.applicationURL = URL(fileURLWithPath: "foo/bar.app")
                }
                
                it("is true") {
                    expect(subject.isAvailable(osxApplicationFinder: osxApplicationFinder)).to(beTrue())
                }
            }
            
            context("when application finder doesn't find the app with bundleID") {
                beforeEach {
                    osxApplicationFinder.applicationURL = nil
                }
                
                it("is false") {
                    expect(subject.isAvailable(osxApplicationFinder: osxApplicationFinder)).to(beFalse())
                }
            }
        }
        
        describe(".view") {
            var testResult: SnapshotTestResult!
            var build: Build!
            var testInformation: SnapshotTestInformation!
            
            beforeEach {
                build = Build(date: Date(), applicationName: "MyApp", fbReferenceImageDirectoryURLs: [URL(fileURLWithPath: "foo/bar", isDirectory: true)])
                testInformation = SnapshotTestInformation(testClassName: "ExampleTestClass", testName: "testName", testFilePath: "testFilePath", testLineNumber: 1)
            }
            
            context("for recorded snapshot test result") {
                beforeEach {
                    testResult = SnapshotTestResult.recorded(testInformation: testInformation, referenceImagePath: "foo/bar/referenceImage.png", build: build)
                }
                
                it("launches correct process") {
                    subject.view(snapshotTestResult: testResult, using: processLauncher)
                    expect(processLauncher.launchedProcessArguments).to(equal(["xed", "-l", "1", "testFilePath"]))
                    expect(processLauncher.launchedProcessPath).to(equal("/usr/bin/xcrun"))
                }
            }
            
            context("for failed snapshot test result") {
                beforeEach {
                    testResult = SnapshotTestResult.failed(testInformation: testInformation, referenceImagePath: "foo/bar/referenceImage.png", diffImagePath: "foo/bar/diffImage.png", failedImagePath: "foo/bar/failedImage.png", build: build)
                }
                
                it("launches correct process") {
                    subject.view(snapshotTestResult: testResult, using: processLauncher)
                    expect(processLauncher.launchedProcessArguments).to(equal(["xed", "-l", "1", "testFilePath"]))
                    expect(processLauncher.launchedProcessPath).to(equal("/usr/bin/xcrun"))
                }
            }
        }
    }
}
