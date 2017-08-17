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
        var errorLogLine: ApplicationLogLine!
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
            context("when unknown log line") {
                var createdTestResult: SnapshotTestResult?
                
                beforeEach {
                    errorLogLine = ApplicationLogLine.snapshotTestErrorMessage(line: "/Users/antondomashnev/Work/FBSnapshotsViewerExample/FBSnapshotsViewerExampleTests/FBSnapshotsViewerExampleTests.m:38: error: -[FBSnapshotsViewerExampleTests testRecord] : ((noErrors) is true) failed - Snapshot comparison failed: (null)")
                    createdTestResult = factory.createSnapshotTestResult(from: .unknown, errorLine: errorLogLine, build: build)
                }
                
                it("doesnt create test result") {
                    expect(createdTestResult).to(beNil())
                }
            }
            
            context("when application name log line") {
                var createdTestResult: SnapshotTestResult?
                
                beforeEach {
                    errorLogLine = ApplicationLogLine.snapshotTestErrorMessage(line: "/Users/antondomashnev/Work/FBSnapshotsViewerExample/FBSnapshotsViewerExampleTests/FBSnapshotsViewerExampleTests.m:38: error: -[FBSnapshotsViewerExampleTests testRecord] : ((noErrors) is true) failed - Snapshot comparison failed: (null)")
                    createdTestResult = factory.createSnapshotTestResult(from: .applicationNameMessage(line: "MyApp"), errorLine: errorLogLine, build: build)
                }
                
                it("doesnt create test result") {
                    expect(createdTestResult).to(beNil())
                }
            }
            
            context("when fb image reference dir log line") {
                var createdTestResult: SnapshotTestResult?
                
                beforeEach {
                    errorLogLine = ApplicationLogLine.snapshotTestErrorMessage(line: "/Users/antondomashnev/Work/FBSnapshotsViewerExample/FBSnapshotsViewerExampleTests/FBSnapshotsViewerExampleTests.m:38: error: -[FBSnapshotsViewerExampleTests testRecord] : ((noErrors) is true) failed - Snapshot comparison failed: (null)")
                    createdTestResult = factory.createSnapshotTestResult(from: .fbReferenceImageDirMessage(line: "MyApp"), errorLine: errorLogLine, build: build)
                }
                
                it("doesnt create test result") {
                    expect(createdTestResult).to(beNil())
                }
            }
            
            context("when reference image saved message log line") {
                var createdTestResult: SnapshotTestResult!
                var referenceImageSavedMessage: ApplicationLogLine!

                context("given invalid error line") {
                    beforeEach {
                        errorLogLine = ApplicationLogLine.snapshotTestErrorMessage(line: "Olololo")
                        referenceImageSavedMessage = ApplicationLogLine.referenceImageSavedMessage(line: "Reference image save at: /Users/antondomashnev/Work/FBSnapshotsViewerExample/FBSnapshotsViewerExampleTests/ReferenceImages_64/FBSnapshotsViewerExampleTests/testRecord@2x.png")
                    }
                    
                    it("returns nil") {
                        expect(factory.createSnapshotTestResult(from: referenceImageSavedMessage, errorLine: errorLogLine, build: build)).to(beNil())
                    }
                }
                
                context("given valid error line") {
                    beforeEach {
                        errorLogLine = ApplicationLogLine.snapshotTestErrorMessage(line: "/Users/antondomashnev/Work/FBSnapshotsViewerExample/FBSnapshotsViewerExampleTests/FBSnapshotsViewerExampleTests.m:38: error: -[FBSnapshotsViewerExampleTests testRecord] : ((noErrors) is true) failed - Snapshot comparison failed: (null)")
                    }
                    
                    context("given invalid referenceImageSavedMessage") {
                        context("when without expected FBSnapshotTests message") {
                            beforeEach {
                                referenceImageSavedMessage = ApplicationLogLine.referenceImageSavedMessage(line: "Reference image was saved /Users/antondomashnev/Work/FBSnapshotsViewerExample/FBSnapshotsViewerExampleTests/ReferenceImages_64/FBSnapshotsViewerExampleTests/testRecord@2x.png")
                            }
                            
                            it("returns nil") {
                                expect(factory.createSnapshotTestResult(from: referenceImageSavedMessage, errorLine: errorLogLine, build: build)).to(beNil())
                            }
                        }
                        
                        context("when without expected image path suffix") {
                            beforeEach {
                                referenceImageSavedMessage = ApplicationLogLine.referenceImageSavedMessage(line: "Reference image save at: /Users/antondomashnev/Work/FBSnapshotsViewerExample/FBSnapshotsViewerExampleTests/ReferenceImages_64/FBSnapshotsViewerExampleTests/testRecord.png")
                            }
                            
                            it("returns nil") {
                                expect(factory.createSnapshotTestResult(from: referenceImageSavedMessage, errorLine: errorLogLine, build: build)).to(beNil())
                            }
                        }
                    }
                    
                    context("given valid referenceImageSavedMessage") {
                        beforeEach {
                            referenceImageSavedMessage = ApplicationLogLine.referenceImageSavedMessage(line: "Reference image save at: /Users/antondomashnev/Work/FBSnapshotsViewerExample/FBSnapshotsViewerExampleTests/ReferenceImages_64/FBSnapshotsViewerExampleTests/testRecord@2x.png")
                            createdTestResult = factory.createSnapshotTestResult(from: referenceImageSavedMessage, errorLine: errorLogLine, build: build)
                        }
                        
                        it("creates recorded test result") {
                            let exoectedTestIformation = SnapshotTestInformation(testClassName: "FBSnapshotsViewerExampleTests", testName: "testRecord", testFilePath: "/Users/antondomashnev/Work/FBSnapshotsViewerExample/FBSnapshotsViewerExampleTests/FBSnapshotsViewerExampleTests.m", testLineNumber: 38)
                            let expectedTestResult = SnapshotTestResult.recorded(testInformation: expectedTestInformation, referenceImagePath: "/Users/antondomashnev/Work/FBSnapshotsViewerExample/FBSnapshotsViewerExampleTests/ReferenceImages_64/FBSnapshotsViewerExampleTests/testRecord@2x.png", build: build)
                            expect(createdTestResult).to(equal(expectedTestResult))
                        }
                    }
                }
            }

            context("when kaleidoscope command message log line") {
                var kaleidoscopeCommandMessage: ApplicationLogLine!
                var createdTestResult: SnapshotTestResult!

                context("given invalid error line") {
                    beforeEach {
                        errorLogLine = ApplicationLogLine.snapshotTestErrorMessage(line: "Shalalala")
                        kaleidoscopeCommandMessage = ApplicationLogLine.kaleidoscopeCommandMessage(line: "ksdiff \"/Users/antondomashnev/Library/Developer/CoreSimulator/Devices/B1AC0517-7FC0-4B32-8543-9EC263071FE5/data/Containers/Data/Application/8EEE157C-41B9-47F8-8634-CF3D60962E19/tmp/FBSnapshotsViewerExampleTests/reference_testFail@2x.png\" \"/Users/antondomashnev/Library/Developer/CoreSimulator/Devices/B1AC0517-7FC0-4B32-8543-9EC263071FE5/data/Containers/Data/Application/8EEE157C-41B9-47F8-8634-CF3D60962E19/tmp/FBSnapshotsViewerExampleTests/failed_testFail@2x.png\"")
                    }
                    
                    it("returns nil") {
                        expect(factory.createSnapshotTestResult(from: kaleidoscopeCommandMessage, errorLine: errorLogLine, build: build)).to(beNil())
                    }
                }
                
                context("given valid error line") {
                    beforeEach {
                        errorLogLine = ApplicationLogLine.snapshotTestErrorMessage(line: "/Users/antondomashnev/Work/FBSnapshotsViewerExample/FBSnapshotsViewerExampleTests/FBSnapshotsViewerExampleTests.m:27: error: -[FBSnapshotsViewerExampleTests testFail] : ((noErrors) is true) failed - Snapshot comparison failed: Error Domain=FBSnapshotTestControllerErrorDomain Code=4 \"Images different\" UserInfo={NSLocalizedFailureReason=image pixels differed by more than 0.00% from the reference image, FBDiffedImageKey=<UIImage: 0x6000002909a0>, {375, 667}, FBReferenceImageKey=<UIImage: 0x60000028fff0>, {375, 667}, FBCapturedImageKey=<UIImage: 0x600000290950>, {375, 667}, NSLocalizedDescription=Images different}")
                    }
                    
                    context("given invalid kaleidoscopeCommandMessage") {
                        context("when without expected FBSnapshotTests message") {
                            beforeEach {
                                kaleidoscopeCommandMessage = ApplicationLogLine.kaleidoscopeCommandMessage(line: "ksdifference \"/Users/antondomashnev/Library/Developer/CoreSimulator/Devices/B1AC0517-7FC0-4B32-8543-9EC263071FE5/data/Containers/Data/Application/8EEE157C-41B9-47F8-8634-CF3D60962E19/tmp/FBSnapshotsViewerExampleTests/reference_testFail@2x.png\"")
                            }
                            
                            it("returns nil") {
                                expect(factory.createSnapshotTestResult(from: kaleidoscopeCommandMessage, errorLine: errorLogLine, build: build)).to(beNil())
                            }
                        }
                        
                        context("when without proper failed image path") {
                            beforeEach {
                                kaleidoscopeCommandMessage = ApplicationLogLine.kaleidoscopeCommandMessage(line: "ksdiff \"/Users/antondomashnev/Library/Developer/CoreSimulator/Devices/B1AC0517-7FC0-4B32-8543-9EC263071FE5/data/Containers/Data/Application/8EEE157C-41B9-47F8-8634-CF3D60962E19/tmp/FBSnapshotsViewerExampleTests/reference_testFail.png\" \"\"")
                            }
                            
                            it("returns nil") {
                                expect(factory.createSnapshotTestResult(from: kaleidoscopeCommandMessage, errorLine: errorLogLine, build: build)).to(beNil())
                            }
                        }
                    }
                    
                    context("given valid kaleidoscopeCommandMessage") {
                        beforeEach {
                            kaleidoscopeCommandMessage = ApplicationLogLine.kaleidoscopeCommandMessage(line: "ksdiff \"/Users/antondomashnev/Library/Developer/CoreSimulator/Devices/B1AC0517-7FC0-4B32-8543-9EC263071FE5/data/Containers/Data/Application/8EEE157C-41B9-47F8-8634-CF3D60962E19/tmp/FBSnapshotsViewerExampleTests/reference_testFail@2x.png\" \"/Users/antondomashnev/Library/Developer/CoreSimulator/Devices/B1AC0517-7FC0-4B32-8543-9EC263071FE5/data/Containers/Data/Application/8EEE157C-41B9-47F8-8634-CF3D60962E19/tmp/FBSnapshotsViewerExampleTests/failed_testFail@2x.png\"")
                            createdTestResult = factory.createSnapshotTestResult(from: kaleidoscopeCommandMessage, errorLine: errorLogLine, build: build)
                        }
                        
                        it("creates failed test result") {
                            let expectedTestInformation = SnapshotTestInformation(testClassName: "FBSnapshotsViewerExampleTests", testName: "testFail", testFilePath: "/Users/antondomashnev/Work/FBSnapshotsViewerExample/FBSnapshotsViewerExampleTests/FBSnapshotsViewerExampleTests.m", testLineNumber: 27)
                            let expectedTestResult = SnapshotTestResult.failed(testInformation: expectedTestInformation, referenceImagePath: "/Users/antondomashnev/Library/Developer/CoreSimulator/Devices/B1AC0517-7FC0-4B32-8543-9EC263071FE5/data/Containers/Data/Application/8EEE157C-41B9-47F8-8634-CF3D60962E19/tmp/FBSnapshotsViewerExampleTests/reference_testFail@2x.png", diffImagePath: "/Users/antondomashnev/Library/Developer/CoreSimulator/Devices/B1AC0517-7FC0-4B32-8543-9EC263071FE5/data/Containers/Data/Application/8EEE157C-41B9-47F8-8634-CF3D60962E19/tmp/FBSnapshotsViewerExampleTests/diff_testFail@2x.png", failedImagePath: "/Users/antondomashnev/Library/Developer/CoreSimulator/Devices/B1AC0517-7FC0-4B32-8543-9EC263071FE5/data/Containers/Data/Application/8EEE157C-41B9-47F8-8634-CF3D60962E19/tmp/FBSnapshotsViewerExampleTests/failed_testFail@2x.png", build: build)
                            expect(createdTestResult).to(equal(expectedTestResult))
                            
                        }
                    }
                }
            }
        }
    }
}
