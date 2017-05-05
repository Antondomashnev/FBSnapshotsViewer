//
//  KaleidoscopeViewerSpec.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 06.05.17.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Foundation
import Quick
import Nimble

@testable import FBSnapshotsViewer

class KaleidoscopeViewer_MockProcessLauncher: ProcessLauncher {
    var launchedProcessPath: String?
    var launchedProcessArguments: [String]?

    override func launchProcess(at launchPath: String, with arguments: [String]?) {
        launchedProcessPath = launchPath
        launchedProcessArguments = arguments
    }
}

class KaleidoscopeViewer_MockOSXApplicationFinder: OSXApplicationFinder {
    var applicationURL: URL?

    override func findApplication(with bundleIdentifier: String) -> URL? {
        return applicationURL
    }
}

class KaleidoscopeViewerSpec: QuickSpec {
    override func spec() {
        var processLauncher: KaleidoscopeViewer_MockProcessLauncher!
        var osxApplicationFinder: KaleidoscopeViewer_MockOSXApplicationFinder!

        beforeEach {
            processLauncher = KaleidoscopeViewer_MockProcessLauncher()
            osxApplicationFinder = KaleidoscopeViewer_MockOSXApplicationFinder()
        }

        describe("name") {
            it("is Kaleidoscope") {
                expect(KaleidoscopeViewer.name).to(equal("Kaleidoscope"))
            }
        }

        describe("bundleID") {
            it("is correct") {
                expect(KaleidoscopeViewer.bundleID).to(equal("com.blackpixel.kaleidoscope"))
            }
        }

        describe(".isAvailable") {
            context("when application finder finds the app with bundleID") {
                beforeEach {
                    osxApplicationFinder.applicationURL = URL(fileURLWithPath: "foo/bar.app")
                }

                it("is true") {
                    expect(KaleidoscopeViewer.isAvailable(osxApplicationFinder: osxApplicationFinder)).to(beTrue())
                }
            }

            context("when application finder doesn't find the app with bundleID") {
                beforeEach {
                    osxApplicationFinder.applicationURL = nil
                }

                it("is false") {
                    expect(KaleidoscopeViewer.isAvailable(osxApplicationFinder: osxApplicationFinder)).to(beFalse())
                }
            }
        }

        describe(".view") {
            var testResult: SnapshotTestResult!

            context("for recorded snapshot test result") {
                beforeEach {
                    testResult = SnapshotTestResult.recorded(testName: "testName", referenceImagePath: "foo/bar/referenceImage.png")
                }

                it("throws an assertion") {
                    expect { KaleidoscopeViewer.view(snapshotTestResult: testResult, using: processLauncher) }.to(throwAssertion())
                }
            }

            context("for failed snapshot test result") {
                beforeEach {
                    testResult = SnapshotTestResult.failed(testName: "testName", referenceImagePath: "foo/bar/referenceImage.png", diffImagePath: "foo/bar/diffImage.png", failedImagePath: "foo/bar/failedImage.png")
                }

                it("launches correct process") {
                    KaleidoscopeViewer.view(snapshotTestResult: testResult, using: processLauncher)
                    expect(processLauncher.launchedProcessArguments).to(equal(["foo/bar/referenceImage.png", "foo/bar/failedImage.png"]))
                    expect(processLauncher.launchedProcessPath).to(equal("/usr/local/bin/ksdiff"))
                }
            }
        }
    }
}
