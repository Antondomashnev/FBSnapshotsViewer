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

private class TestFilePathExtractorMock: TestFilePathExtractor {
    var extractTestClassPathFromThrows = false
    var extractTestClassPathFromCalled = false
    var extractTestClassPathFromReceivedLogLine: ApplicationLogLine?
    var extractTestClassPathFromReturnValue: String!
    
    func extractTestClassPath(from logLine: ApplicationLogLine) throws -> String {
        if extractTestClassPathFromThrows {
            throw NSError(domain: "", code: 0, userInfo: nil)
        }
        extractTestClassPathFromCalled = true
        extractTestClassPathFromReceivedLogLine = logLine
        return extractTestClassPathFromReturnValue
    }
}

private class TestLineNumberExtractorMock: TestLineNumberExtractor {
    var extractTestLineNumberFromThrows = false
    var extractTestLineNumberFromCalled = false
    var extractTestLineNumberFromReceivedLogLine: ApplicationLogLine?
    var extractTestLineNumberFromReturnValue: Int!
    
    func extractTestLineNumber(from logLine: ApplicationLogLine) throws -> Int {
        if extractTestLineNumberFromThrows {
            throw NSError(domain: "", code: 0, userInfo: nil)
        }
        extractTestLineNumberFromCalled = true
        extractTestLineNumberFromReceivedLogLine = logLine
        return extractTestLineNumberFromReturnValue
    }
}

class SnapshotTestResultFactorySpec: QuickSpec {
    override func spec() {
        var build: Build!
        var factory: SnapshotTestResultFactory!
        var testLineNumberExtractor: TestLineNumberExtractorMock!
        var testFilePathExtractor: TestFilePathExtractorMock!

        beforeEach {
            build = Build(date: Date(), applicationName: "FBSnapshotsViewer", fbReferenceImageDirectoryURLs: [URL(fileURLWithPath: "foo/bar", isDirectory: true)])
            testLineNumberExtractor = TestLineNumberExtractorMock()
            testFilePathExtractor = TestFilePathExtractorMock()
            factory = SnapshotTestResultFactory(testFilePathExtractor: testFilePathExtractor, testLineNumberExtractor: testLineNumberExtractor)
        }

        describe(".createSnapshotTestResult(from:)") {
            context("when recordedSnapshotTestResultLines") {
                var createdTestResult: SnapshotTestResult!
                var referenceImageSavedLines: SnapshotTestResultLogLines!

                context("when invalid error message") {
                    var resultMessage: ApplicationLogLine!
                    
                    beforeEach {
                        resultMessage = ApplicationLogLine.referenceImageSavedMessage(line: "2017-04-25 21:15:37.107 FBSnapshotsViewerExample[56034:787919] Reference image save at: /Users/antondomashnev/Work/FBSnapshotsViewerExample/FBSnapshotsViewerExampleTests/ReferenceImages_64/FBSnapshotsViewerExampleTests/testRecord@2x.png")
                    }
                    
                    context("when line number cannot be extracted") {
                        beforeEach {
                            testLineNumberExtractor.extractTestLineNumber_from_Throws = true
                            referenceImageSavedLines = SnapshotTestResultLogLines.recordedSnapshotTestResultLines(resultMessage: resultMessage, errorMessage: ApplicationLogLine.snapshotTestErrorMessage(line: "foo/bar"))
                        }
                        
                        it("returns nil") {
                            expect(factory.createSnapshotTestResult(from: referenceImageSavedLines, build: build)).to(beNil())
                        }
                    }
                    
                    context("when test file path cannot be extracted") {
                        beforeEach {
                            testFilePathExtractor.extractTestClassPathFromThrows = true
                            referenceImageSavedLines = SnapshotTestResultLogLines.recordedSnapshotTestResultLines(resultMessage: resultMessage, errorMessage: ApplicationLogLine.snapshotTestErrorMessage(line: "foo/bar"))
                        }
                        
                        it("returns nil") {
                            expect(factory.createSnapshotTestResult(from: referenceImageSavedLines, build: build)).to(beNil())
                        }
                    }
                }
                
                context("when invalid result message") {
                    var errorMessage: String!
                    
                    beforeEach {
                        errorMessage = "/Users/antondomashnev/Work/FBSnapshotsViewerExample/FBSnapshotsViewerExampleTests/FBSnapshotsViewerExampleTests.m:38: error: -[FBSnapshotsViewerExampleTests testRecord] : ((noErrors) is true) failed - Snapshot comparison failed: (null)"
                    }
                    
                    context("when without expected FBSnapshotTests message") {
                        beforeEach {
                            referenceImageSavedLines = SnapshotTestResultLogLines.recordedSnapshotTestResultLines(resultMessage: "Reference image was saved /Users/antondomashnev/Work/FBSnapshotsViewerExample/FBSnapshotsViewerExampleTests/ReferenceImages_64/FBSnapshotsViewerExampleTests/testRecord@2x.png", errorMessage: errorMessage)
                        }

                        it("returns nil") {
                            expect(factory.createSnapshotTestResult(from: referenceImageSavedLines, build: build)).to(beNil())
                        }
                    }

                    context("when without expected image path suffix") {
                        beforeEach {
                            referenceImageSavedLines = SnapshotTestResultLogLines.recordedSnapshotTestResultLines(resultMessage: "Reference image save at: /Users/antondomashnev/Work/FBSnapshotsViewerExample/FBSnapshotsViewerExampleTests/ReferenceImages_64/FBSnapshotsViewerExampleTests/testRecord.png", errorMessage: errorMessage)
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
                        let expectedTestResult = SnapshotTestResult.recorded(testInformation: SnapshotTestInformation(testClassName: "FBSnapshotsViewerExampleTests", testName: "testRecord"), referenceImagePath: "/Users/antondomashnev/Work/FBSnapshotsViewerExample/FBSnapshotsViewerExampleTests/ReferenceImages_64/FBSnapshotsViewerExampleTests/testRecord@2x.png", build: build)
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
                        let expectedTestResult = SnapshotTestResult.failed(testInformation: SnapshotTestInformation(testClassName: "FBSnapshotsViewerExampleTests", testName: "testFail"), referenceImagePath: "/Users/antondomashnev/Library/Developer/CoreSimulator/Devices/B1AC0517-7FC0-4B32-8543-9EC263071FE5/data/Containers/Data/Application/8EEE157C-41B9-47F8-8634-CF3D60962E19/tmp/FBSnapshotsViewerExampleTests/reference_testFail@2x.png", diffImagePath: "/Users/antondomashnev/Library/Developer/CoreSimulator/Devices/B1AC0517-7FC0-4B32-8543-9EC263071FE5/data/Containers/Data/Application/8EEE157C-41B9-47F8-8634-CF3D60962E19/tmp/FBSnapshotsViewerExampleTests/diff_testFail@2x.png", failedImagePath: "/Users/antondomashnev/Library/Developer/CoreSimulator/Devices/B1AC0517-7FC0-4B32-8543-9EC263071FE5/data/Containers/Data/Application/8EEE157C-41B9-47F8-8634-CF3D60962E19/tmp/FBSnapshotsViewerExampleTests/failed_testFail@2x.png", build: build)
                        expect(createdTestResult).to(equal(expectedTestResult))
                        
                    }
                }
            }
        }
    }
}
