//
//  ApplicationSnapshotTestResultListenerSpec.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 29.04.17.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Quick
import Nimble
import KZFileWatchers

@testable import FBSnapshotsViewer

class ApplicationSnapshotTestResultListener_MockFileWatcherProtocol: KZFileWatchers.FileWatcherProtocol {
    var startClosure: KZFileWatchers.FileWatcher.UpdateClosure?
    var startCalled: Bool = false
    var startError: KZFileWatchers.FileWatcher.Error?
    func start(closure: @escaping KZFileWatchers.FileWatcher.UpdateClosure) throws {
        startClosure = closure
        startCalled = true
        if let startError = startError {
            throw startError
        }
    }

    var stopCalled: Bool = false
    func stop() {
        stopCalled = true
    }
}

class ApplicationSnapshotTestResultListener_MockApplicationLogReader: ApplicationLogReader {
    var readLines: [ApplicationLogLine] = []
    override func readline(of logText: String, startingFrom lineNumber: Int) -> [ApplicationLogLine] {
        return readLines
    }
}

class ApplicationSnapshotTestResultListener_MockSnapshotTestResultFactory: SnapshotTestResultFactory {
    var createdSnapshotTestResultForLogLine: [ApplicationLogLine: SnapshotTestResult] = [:]
    override func createSnapshotTestResult(from logLine: ApplicationLogLine) -> SnapshotTestResult? {
        return createdSnapshotTestResultForLogLine[logLine]
    }
}

class ApplicationSnapshotTestResultListenerSpec: QuickSpec {
    override func spec() {
        var fileWatcher: ApplicationSnapshotTestResultListener_MockFileWatcherProtocol!
        var logReader: ApplicationSnapshotTestResultListener_MockApplicationLogReader!
        var snapshotTestResultFactory: ApplicationSnapshotTestResultListener_MockSnapshotTestResultFactory!
        var listener: ApplicationSnapshotTestResultListener!

        beforeEach {
            snapshotTestResultFactory = ApplicationSnapshotTestResultListener_MockSnapshotTestResultFactory()
            fileWatcher = ApplicationSnapshotTestResultListener_MockFileWatcherProtocol()
            logReader = ApplicationSnapshotTestResultListener_MockApplicationLogReader()
            listener = ApplicationSnapshotTestResultListener(fileWatcher: fileWatcher, applicationLogReader: logReader, snapshotTestResultFactory: snapshotTestResultFactory)
        }

        describe(".stopListening") {
            it("stops file watching") {
                listener.stopListening()
                expect(fileWatcher.stopCalled).to(beTrue())
            }
        }

        describe(".receiving new file watch event") {
            var receivedSnapshotTestResults: [SnapshotTestResult] = []
            let unknownLogLine = ApplicationLogLine.unknown
            let kaleidoscopeCommandMesageLogLine = ApplicationLogLine.kaleidoscopeCommandMessage(line: "BlaBla")
            let referenceImageSavedMessageLogLine = ApplicationLogLine.referenceImageSavedMessage(line: "FooFoo")
            let failedSnapshotTestResult = SnapshotTestResult.failed(testName: "failedTest", referenceImagePath: "referenceTestImage.png", diffImagePath: "diffTestImage.png", failedImagePath: "failedTestImage.png")
            let recordedSnapshotTestResult = SnapshotTestResult.recorded(testName: "recordedTest", referenceImagePath: "referenceTestImage.png")

            beforeEach {
                snapshotTestResultFactory.createdSnapshotTestResultForLogLine[kaleidoscopeCommandMesageLogLine] = failedSnapshotTestResult
                snapshotTestResultFactory.createdSnapshotTestResultForLogLine[referenceImageSavedMessageLogLine] = recordedSnapshotTestResult
                logReader.readLines = [kaleidoscopeCommandMesageLogLine, unknownLogLine, referenceImageSavedMessageLogLine]
                listener.startListening { result in
                    receivedSnapshotTestResults += [result]
                }
            }

            context("with no changes") {
                beforeEach {
                    fileWatcher.startClosure?(.noChanges)
                }

                it("doesnt output anything") {
                    expect(receivedSnapshotTestResults.isEmpty).to(beTrue())
                }
            }

            context("with invalid updates") {
                it("thows assertion") {
                    expect { fileWatcher.startClosure?(.updated(data: Data())) }.to(throwAssertion())
                }
            }

            context("with valid updates") {
                beforeEach {
                    let update: Data! = "new updated text".data(using: .utf8, allowLossyConversion: false)
                    fileWatcher.startClosure?(.updated(data: update))
                }

                it("outputs expected snapshot test resilts") {
                    expect(receivedSnapshotTestResults).to(equal([failedSnapshotTestResult, recordedSnapshotTestResult]))
                }
            }
        }

        describe("startListening(outputTo:)") {
            it("starts file watching") {
                listener.startListening { _ in }
                expect(fileWatcher.startCalled).to(beTrue())
            }

            context("when file watcher fails to start") {
                context("because already started") {
                    beforeEach {
                        fileWatcher.startError = KZFileWatchers.FileWatcher.Error.alreadyStarted
                    }

                    it("throws assertion") {
                        expect { listener.startListening { _ in } }.to(throwAssertion())
                    }
                }

                context("because of internal error") {
                    beforeEach {
                        fileWatcher.startError = KZFileWatchers.FileWatcher.Error.failedToStart(reason: "Unknown")
                    }

                    it("does nothing") {
                        listener.startListening { _ in }
                    }
                }

                context("because of unknown reason") {
                    beforeEach {
                        fileWatcher.startError = KZFileWatchers.FileWatcher.Error.notStarted
                    }

                    it("does nothing") {
                        listener.startListening { _ in }
                    }
                }
            }
        }
    }
}
