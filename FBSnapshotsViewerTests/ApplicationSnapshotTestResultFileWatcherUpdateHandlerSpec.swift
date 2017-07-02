//
//  ApplicationSnapshotTestResultFileWatcherUpdateHandlerSpec.swift
//  FBSnapshotsViewerTests
//
//  Created by Anton Domashnev on 24.06.17.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Quick
import Nimble

@testable import FBSnapshotsViewer

class ApplicationSnapshotTestResultFileWatcherUpdateHandler_MockApplicationLogReader: ApplicationLogReader {
    var readLines: [ApplicationLogLine] = []
    override func readline(of logText: String, startingFrom lineNumber: Int) -> [ApplicationLogLine] {
        return readLines
    }
}

class ApplicationSnapshotTestResultFileWatcherUpdateHandler_MockSnapshotTestResultFactory: SnapshotTestResultFactory {
    var createdSnapshotTestResultForLogLine: [ApplicationLogLine: SnapshotTestResult] = [:]
    var givenBuild: Build!
    override func createSnapshotTestResult(from logLine: ApplicationLogLine, build: Build) -> SnapshotTestResult? {
        givenBuild = build
        return createdSnapshotTestResultForLogLine[logLine]
    }
}

class ApplicationSnapshotTestResultFileWatcherUpdateHandler_MockApplicationNameExtractor: ApplicationNameExtractor {
    var extractApplicationNameCalled = false
    var extractApplicationNameThrows = false
    var extractApplicationNameReceivedLogLine: ApplicationLogLine?
    var extractApplicationNameReturnValue: String!
    
    func extractApplicationName(from logLine: ApplicationLogLine) throws -> String {
        if extractApplicationNameThrows {
            throw NSError(domain: "", code: 0, userInfo: nil)
        }
        extractApplicationNameCalled = true
        extractApplicationNameReceivedLogLine = logLine
        return extractApplicationNameReturnValue
    }
}

class ApplicationSnapshotTestResultFileWatcherUpdateHandler_MockBuildCreator: BuildCreator {
    var createdBuild: Build?
    
    override func createBuild() -> Build? {
        return createdBuild
    }
}

class ApplicationSnapshotTestResultFileWatcherUpdateHandler__MockFBReferenceImageDirectoryURLExtractor: FBReferenceImageDirectoryURLExtractor {
    var extractImageDirectoryURLCalled = false
    var extractImageDirectoryURLThrows = false
    var extractImageDirectoryURLReceivedLogLine: ApplicationLogLine?
    var extractImageDirectoryURLReturnValue: URL!
    
    func extractImageDirectoryURL(from logLine: ApplicationLogLine) throws -> URL {
        if extractImageDirectoryURLThrows {
            throw NSError(domain: "", code: 0, userInfo: nil)
        }
        extractImageDirectoryURLCalled = true
        extractImageDirectoryURLReceivedLogLine = logLine
        return extractImageDirectoryURLReturnValue
    }
}

class ApplicationSnapshotTestResultFileWatcherUpdateHandlerSpec: QuickSpec {
    override func spec() {
        var logReader: ApplicationSnapshotTestResultFileWatcherUpdateHandler_MockApplicationLogReader!
        var snapshotTestResultFactory: ApplicationSnapshotTestResultFileWatcherUpdateHandler_MockSnapshotTestResultFactory!
        var applicationNameExtractor: ApplicationSnapshotTestResultFileWatcherUpdateHandler_MockApplicationNameExtractor!
        var buildCreator: ApplicationSnapshotTestResultFileWatcherUpdateHandler_MockBuildCreator!
        var fbImageReferenceDirExtractor: ApplicationSnapshotTestResultFileWatcherUpdateHandler__MockFBReferenceImageDirectoryURLExtractor!
        var updateHandler: ApplicationSnapshotTestResultFileWatcherUpdateHandler!
        
        beforeEach {
            logReader = ApplicationSnapshotTestResultFileWatcherUpdateHandler_MockApplicationLogReader()
            applicationNameExtractor = ApplicationSnapshotTestResultFileWatcherUpdateHandler_MockApplicationNameExtractor()
            snapshotTestResultFactory = ApplicationSnapshotTestResultFileWatcherUpdateHandler_MockSnapshotTestResultFactory()
            buildCreator = ApplicationSnapshotTestResultFileWatcherUpdateHandler_MockBuildCreator()
            fbImageReferenceDirExtractor = ApplicationSnapshotTestResultFileWatcherUpdateHandler__MockFBReferenceImageDirectoryURLExtractor()
            let builder = ApplicationSnapshotTestResultFileWatcherUpdateHandlerBuilder {
                $0.applicationNameExtractor = applicationNameExtractor
                $0.fbImageReferenceDirExtractor = fbImageReferenceDirExtractor
                $0.snapshotTestResultFactory = snapshotTestResultFactory
                $0.buildCreator = buildCreator
                $0.applicationLogReader = logReader
            }
            updateHandler = ApplicationSnapshotTestResultFileWatcherUpdateHandler(builder: builder)
        }
        
        describe(".handleFileWatcherUpdate") {
            let build = Build(date: Date(), applicationName: "MyApp", fbReferenceImageDirectoryURL: URL(fileURLWithPath: "foo/bar", isDirectory: true))
            let unknownLogLine = ApplicationLogLine.unknown
            let applicationNameMessageLogLine = ApplicationLogLine.applicationNameMessage(line: "MyApp")
            let kaleidoscopeCommandMesageLogLine = ApplicationLogLine.kaleidoscopeCommandMessage(line: "BlaBla")
            let referenceImageSavedMessageLogLine = ApplicationLogLine.referenceImageSavedMessage(line: "FooFoo")
            let fbReferenceImageDirMessageLogLine = ApplicationLogLine.fbReferenceImageDirMessage(line: "foo/bar")
            let failedSnapshotTestResult = SnapshotTestResult.failed(testInformation: SnapshotTestInformation(testClassName: "Foo", testName: "failedTest"), referenceImagePath: "referenceTestImage.png", diffImagePath: "diffTestImage.png", failedImagePath: "failedTestImage.png", build: build)
            let recordedSnapshotTestResult = SnapshotTestResult.recorded(testInformation: SnapshotTestInformation(testClassName: "Bar", testName: "recordedTest"), referenceImagePath: "referenceTestImage.png", build: build)
            
            beforeEach {
                applicationNameExtractor.extractApplicationNameReturnValue = "MyApp"
                fbImageReferenceDirExtractor.extractImageDirectoryURLReturnValue = URL(fileURLWithPath: "foo/bar", isDirectory: true)
                snapshotTestResultFactory.createdSnapshotTestResultForLogLine[kaleidoscopeCommandMesageLogLine] = failedSnapshotTestResult
                snapshotTestResultFactory.createdSnapshotTestResultForLogLine[referenceImageSavedMessageLogLine] = recordedSnapshotTestResult
                logReader.readLines = [unknownLogLine, fbReferenceImageDirMessageLogLine, applicationNameMessageLogLine, kaleidoscopeCommandMesageLogLine, referenceImageSavedMessageLogLine]
            }
            
            context("with no changes") {
                it("outputs empty array") {
                    expect(updateHandler.handleFileWatcherUpdate(result: .noChanges)).to(equal([]))
                }
            }
            
            context("with invalid updates") {
                it("thows assertion") {
                    expect { updateHandler.handleFileWatcherUpdate(result: .updated(data: Data())) }.to(throwAssertion())
                }
            }
            
            context("with valid updates") {
                let update: Data! = "new updated text".data(using: .utf8, allowLossyConversion: false)
                
                it("assigns values to buildCreator") {
                    buildCreator.createdBuild = build
                    
                    updateHandler.handleFileWatcherUpdate(result: .updated(data: update))
                    
                    expect(buildCreator.date).toNot(beNil())
                    expect(buildCreator.applicationName).to(equal(applicationNameExtractor.extractApplicationNameReturnValue))
                    expect(buildCreator.fbReferenceImageDirectoryURL).to(equal(fbImageReferenceDirExtractor.extractImageDirectoryURLReturnValue))
                }
                
                context("when build can not be created") {
                    beforeEach {
                        buildCreator.createdBuild = nil
                    }
                    
                    it("throws assertion") {
                        expect { updateHandler.handleFileWatcherUpdate(result: .updated(data: update)) }.to(throwAssertion())
                    }
                }
                
                context("when fb reference image dir can not be extracted") {
                    beforeEach {
                        fbImageReferenceDirExtractor.extractImageDirectoryURLThrows = true
                    }
                    
                    it("throws assertion") {
                        expect { updateHandler.handleFileWatcherUpdate(result: .updated(data: update)) }.to(throwAssertion())
                    }
                }
                
                context("when application name can not be extracted") {
                    beforeEach {
                        applicationNameExtractor.extractApplicationNameThrows = true
                    }
                    
                    it("throws assertion") {
                        expect { updateHandler.handleFileWatcherUpdate(result: .updated(data: update)) }.to(throwAssertion())
                    }
                }
                
                context("when build can be constructed") {
                    beforeEach {
                        buildCreator.createdBuild = build
                    }
                    
                    it("returns test results") {
                        expect(updateHandler.handleFileWatcherUpdate(result: .updated(data: update))).to(equal([failedSnapshotTestResult, recordedSnapshotTestResult]))
                    }
                }
            }
        }
    }
}
