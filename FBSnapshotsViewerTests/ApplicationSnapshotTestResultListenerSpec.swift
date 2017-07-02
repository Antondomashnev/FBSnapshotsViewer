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

class ApplicationSnapshotTestResultListener_MockApplicationSnapshotTestResultFileWatcherUpdateHandler: ApplicationSnapshotTestResultFileWatcherUpdateHandler {
    var createdTestResults: [SnapshotTestResult] = []
    
    override func handleFileWatcherUpdate(result: KZFileWatchers.FileWatcher.RefreshResult) -> [SnapshotTestResult] {
        return createdTestResults
    }
}

class ApplicationSnapshotTestResultListenerSpec: QuickSpec {
    override func spec() {
        var updatesHandler: ApplicationSnapshotTestResultListener_MockApplicationSnapshotTestResultFileWatcherUpdateHandler!
        var fileWatcher: ApplicationSnapshotTestResultListener_MockFileWatcherProtocol!
        var listener: ApplicationSnapshotTestResultListener!

        beforeEach {
            updatesHandler = ApplicationSnapshotTestResultListener_MockApplicationSnapshotTestResultFileWatcherUpdateHandler()
            fileWatcher = ApplicationSnapshotTestResultListener_MockFileWatcherProtocol()
            listener = ApplicationSnapshotTestResultListener(fileWatcher: fileWatcher, fileWatcherUpdateHandler: updatesHandler)
        }

        describe(".stopListening") {
            it("stops file watching") {
                listener.stopListening()
                expect(fileWatcher.stopCalled).to(beTrue())
            }
        }

        describe(".receiving new file watch event") {
            let update: Data! = "new updated text".data(using: .utf8, allowLossyConversion: false)
            var receivedSnapshotTestResults: [SnapshotTestResult] = []
            
            beforeEach {
                listener.startListening { result in
                    receivedSnapshotTestResults += [result]
                }
            }

            context("when updates handler returns empty array") {
                beforeEach {
                    updatesHandler.createdTestResults = []
                    fileWatcher.startClosure?(.updated(data: update))
                }
                
                it("doesn't call listening callback") {
                    expect(receivedSnapshotTestResults).to(equal([]))
                }
            }
            
            context("when updates handler returns some results") {
                var build: Build!
                
                beforeEach {
                    build = Build(date: Date(), applicationName: "MyApp", fbReferenceImageDirectoryURL: URL(fileURLWithPath: "foo/bar", isDirectory: true))
                }
                
                beforeEach {
                    updatesHandler.createdTestResults = [SnapshotTestResult.recorded(testInformation: SnapshotTestInformation(testClassName: "testClassName", testName: "Foo"), referenceImagePath: "path", build: build)]
                    fileWatcher.startClosure?(.updated(data: update))
                }
                
                it("calls listening callback") {
                    expect(receivedSnapshotTestResults).to(equal(updatesHandler.createdTestResults))
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
