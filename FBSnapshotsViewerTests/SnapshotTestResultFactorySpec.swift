//
//  SnapshotTestResultFactorySpec.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 27.04.17.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Quick
import Nimble

@testable import FBSnapshotsViewer

class SnapshotTestResultFactorySpec: QuickSpec {
    override func spec() {
        var build: Build!
        var factory: SnapshotTestResultFactory!

        beforeEach {
            build = Build(applicationName: "FBSnapshotsViewer")
            factory = SnapshotTestResultFactory()
        }

        describe(".createSnapshotTestResult(from:)") {
            context("when unknown log line") {
                var createdTestResult: SnapshotTestResult?

                beforeEach {
                    createdTestResult = factory.createSnapshotTestResult(from: .unknown, build: build)
                }

                it("doesnt create test result") {
                    expect(createdTestResult).to(beNil())
                }
            }

            context("when reference image saved message log line") {
                var createdTestResult: SnapshotTestResult!
                var referenceImageSavedMessage: ApplicationLogLine!

                context("when invalid") {
                    context("when without expected FBSnapshotTests message") {
                        beforeEach {
                            referenceImageSavedMessage = ApplicationLogLine.referenceImageSavedMessage(line: "Reference image was saved /Users/antondomashnev/Work/FBSnapshotsViewerExample/FBSnapshotsViewerExampleTests/ReferenceImages_64/FBSnapshotsViewerExampleTests/testRecord@2x.png")
                        }

                        it("returns nil") {
                            expect(factory.createSnapshotTestResult(from: referenceImageSavedMessage, build: build)).to(beNil())
                        }
                    }

                    context("when without expected image path suffix") {
                        beforeEach {
                            referenceImageSavedMessage = ApplicationLogLine.referenceImageSavedMessage(line: "Reference image save at: /Users/antondomashnev/Work/FBSnapshotsViewerExample/FBSnapshotsViewerExampleTests/ReferenceImages_64/FBSnapshotsViewerExampleTests/testRecord.png")
                        }

                        it("returns nil") {
                            expect(factory.createSnapshotTestResult(from: referenceImageSavedMessage, build: build)).to(beNil())
                        }
                    }
                }

                context("when valid") {
                    beforeEach {
                        referenceImageSavedMessage = ApplicationLogLine.referenceImageSavedMessage(line: "Reference image save at: /Users/antondomashnev/Work/FBSnapshotsViewerExample/FBSnapshotsViewerExampleTests/ReferenceImages_64/FBSnapshotsViewerExampleTests/testRecord@2x.png")
                        createdTestResult = factory.createSnapshotTestResult(from: referenceImageSavedMessage, build: build)
                    }

                    it("creates recorded test result") {
                        let expectedTestResult = SnapshotTestResult.recorded(testName: "FBSnapshotsViewerExampleTests testRecord", referenceImagePath: "/Users/antondomashnev/Work/FBSnapshotsViewerExample/FBSnapshotsViewerExampleTests/ReferenceImages_64/FBSnapshotsViewerExampleTests/testRecord@2x.png", build: build)
                        expect(createdTestResult).to(equal(expectedTestResult))
                    }
                }
            }

            context("when kaleidoscope command message log line") {
                var kaleidoscopeCommandMessage: ApplicationLogLine!
                var createdTestResult: SnapshotTestResult!

                context("when invalid") {
                    context("when without expected FBSnapshotTests message") {
                        beforeEach {
                            kaleidoscopeCommandMessage = ApplicationLogLine.kaleidoscopeCommandMessage(line: "ksdifference \"/Users/antondomashnev/Library/Developer/CoreSimulator/Devices/B1AC0517-7FC0-4B32-8543-9EC263071FE5/data/Containers/Data/Application/8EEE157C-41B9-47F8-8634-CF3D60962E19/tmp/FBSnapshotsViewerExampleTests/reference_testFail@2x.png\"")
                        }

                        it("returns nil") {
                            expect(factory.createSnapshotTestResult(from: kaleidoscopeCommandMessage, build: build)).to(beNil())
                        }
                    }

                    context("when without proper failed image path") {
                        beforeEach {
                            kaleidoscopeCommandMessage = ApplicationLogLine.kaleidoscopeCommandMessage(line: "ksdiff \"/Users/antondomashnev/Library/Developer/CoreSimulator/Devices/B1AC0517-7FC0-4B32-8543-9EC263071FE5/data/Containers/Data/Application/8EEE157C-41B9-47F8-8634-CF3D60962E19/tmp/FBSnapshotsViewerExampleTests/reference_testFail.png\" \"\"")
                        }

                        it("returns nil") {
                            expect(factory.createSnapshotTestResult(from: kaleidoscopeCommandMessage, build: build)).to(beNil())
                        }
                    }
                }

                context("when valid") {
                    beforeEach {
                        kaleidoscopeCommandMessage = ApplicationLogLine.kaleidoscopeCommandMessage(line: "ksdiff \"/Users/antondomashnev/Library/Developer/CoreSimulator/Devices/B1AC0517-7FC0-4B32-8543-9EC263071FE5/data/Containers/Data/Application/8EEE157C-41B9-47F8-8634-CF3D60962E19/tmp/FBSnapshotsViewerExampleTests/reference_testFail@2x.png\" \"/Users/antondomashnev/Library/Developer/CoreSimulator/Devices/B1AC0517-7FC0-4B32-8543-9EC263071FE5/data/Containers/Data/Application/8EEE157C-41B9-47F8-8634-CF3D60962E19/tmp/FBSnapshotsViewerExampleTests/failed_testFail@2x.png\"")
                        createdTestResult = factory.createSnapshotTestResult(from: kaleidoscopeCommandMessage, build: build)
                    }

                    it("creates failed test result") {
                        let expectedTestResult = SnapshotTestResult.failed(testName: "FBSnapshotsViewerExampleTests testFail", referenceImagePath: "/Users/antondomashnev/Library/Developer/CoreSimulator/Devices/B1AC0517-7FC0-4B32-8543-9EC263071FE5/data/Containers/Data/Application/8EEE157C-41B9-47F8-8634-CF3D60962E19/tmp/FBSnapshotsViewerExampleTests/reference_testFail@2x.png", diffImagePath: "/Users/antondomashnev/Library/Developer/CoreSimulator/Devices/B1AC0517-7FC0-4B32-8543-9EC263071FE5/data/Containers/Data/Application/8EEE157C-41B9-47F8-8634-CF3D60962E19/tmp/FBSnapshotsViewerExampleTests/diff_testFail@2x.png", failedImagePath: "/Users/antondomashnev/Library/Developer/CoreSimulator/Devices/B1AC0517-7FC0-4B32-8543-9EC263071FE5/data/Containers/Data/Application/8EEE157C-41B9-47F8-8634-CF3D60962E19/tmp/FBSnapshotsViewerExampleTests/failed_testFail@2x.png", build: build)
                        expect(createdTestResult).to(equal(expectedTestResult))
                        
                    }
                }
            }
        }
    }
}
