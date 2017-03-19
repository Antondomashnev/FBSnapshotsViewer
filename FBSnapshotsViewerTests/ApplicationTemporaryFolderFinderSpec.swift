//
//  ApplicationTemporaryFolderFinderSpec.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 19/03/2017.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Quick
import Nimble

@testable import FBSnapshotsViewer

class ApplicationTemporaryFolderFinder_MockFolderEventsListener: FolderEventsListener {
    weak var output: FolderEventsListenerOutput?
    var startListeningCalled: Bool = false
    var stopListeningCalled: Bool = false
    var listeningFolderPath: String!

    required init(folderPath: String = "", filter: FolderEventFilter? = nil, fileWatcherFactory: FileWatcherFactory = FileWatcherFactory()) {}

    func startListening() {
        startListeningCalled = true
    }

    func stopListening() {
        stopListeningCalled = true
    }
}

class ApplicationTemporaryFolderFinder_MockFolderEventsListenerFactory: FolderEventsListenerFactory {
    var mockFolderEventsListener: ApplicationTemporaryFolderFinder_MockFolderEventsListener!

    override func iOSSimulatorApplicationsFolderEventsListener(at simulatorPath: String) -> FolderEventsListener {
        mockFolderEventsListener.listeningFolderPath = simulatorPath
        return mockFolderEventsListener
    }
}

class ApplicationTemporaryFolderFinder_MockFileManager: FileManager {
    var mockedFileExistsResult: Bool = false

    override func fileExists(atPath path: String) -> Bool {
        return mockedFileExistsResult
    }
}

class ApplicationTemporaryFolderFinderSpec: QuickSpec {
    override func spec() {
        var folderEventsListener: ApplicationTemporaryFolderFinder_MockFolderEventsListener!
        var temporaryFolderFinder: ApplicationTemporaryFolderFinder!
        var fileManager: ApplicationTemporaryFolderFinder_MockFileManager!
        var folderEventsListenerFactory: ApplicationTemporaryFolderFinder_MockFolderEventsListenerFactory!

        beforeEach {
            folderEventsListener = ApplicationTemporaryFolderFinder_MockFolderEventsListener()
            fileManager = ApplicationTemporaryFolderFinder_MockFileManager()
            folderEventsListenerFactory = ApplicationTemporaryFolderFinder_MockFolderEventsListenerFactory()
            folderEventsListenerFactory.mockFolderEventsListener = folderEventsListener
            temporaryFolderFinder = ApplicationTemporaryFolderFinder(folderEventsListenerFactory: folderEventsListenerFactory, fileManager: fileManager)
        }

        describe(".stopFinding") {
            var output: ApplicationTemporaryFolderFinderOutput!

            beforeEach {
                output = { result in }
                temporaryFolderFinder.find(in: "myfolder/to/find/temporaryfolder/", outputTo: output)
                temporaryFolderFinder.stopFinding()
            }

            it("stops underlying listener") {
                expect(folderEventsListener.stopListeningCalled).to(beTrue())
            }
        }

        describe(".find") {
            var outputCalled: Bool!
            var outputParameter: String!
            var output: ApplicationTemporaryFolderFinderOutput!

            beforeEach {
                outputCalled = false
                outputParameter = ""
                output = { result in
                    outputCalled = true
                    outputParameter = result
                }
                temporaryFolderFinder.find(in: "myfolder/to/find/temporaryfolder/", outputTo: output)
            }

            it("starts listenning for events in the given folder") {
                expect(folderEventsListener.listeningFolderPath).to(equal("myfolder/to/find/temporaryfolder/"))
                expect(folderEventsListener.startListeningCalled).to(beTrue())
            }

            context("when underlying listener outputs app path without temporary folder") {
                beforeEach {
                    fileManager.mockedFileExistsResult = false
                    folderEventsListener.output?.folderEventsListener(folderEventsListener, didReceive: FolderEvent.created(path: "possible/simulator/path/", object: .folder))
                }

                it("doesn't output anything") {
                    expect(outputCalled).to(beFalse())
                }
            }

            context("when underlying listener outputs event without path") {
                it("throws an assertion") {
                    expect(folderEventsListener.output?.folderEventsListener(folderEventsListener, didReceive: FolderEvent.unknown)).to(throwAssertion())
                }
            }

            context("when fhe finding was stoppped") {
                beforeEach {
                    temporaryFolderFinder.stopFinding()
                }

                it("throws an assertion") {
                    expect(folderEventsListener.output?.folderEventsListener(folderEventsListener, didReceive: FolderEvent.created(path: "possible/simulator/path/", object: .folder))).to(throwAssertion())
                }
            }

            context("when underlying listener outputs app path with temporary folder") {
                beforeEach {
                    fileManager.mockedFileExistsResult = true
                    folderEventsListener.output?.folderEventsListener(folderEventsListener, didReceive: FolderEvent.created(path: "possible/simulator/path", object: .folder))
                }

                it("calls output") {
                    expect(outputCalled).to(beTrue())
                }

                it("outputs temporary folder path") {
                    expect(outputParameter).to(equal("possible/simulator/path/tmp"))
                }
            }
        }
    }
}
