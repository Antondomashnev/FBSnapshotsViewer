//
//  NonRecursiveFolderEventsListenerSpec.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 16/03/2017.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Quick
import Nimble

@testable import FBSnapshotsViewer

class NonRecursiveFolderEventsListener_MockFileWatcher: FileWatcher {
    var overridenEventHandler: EventHandler?

    override func start(with eventHandler: @escaping FileWatcher.EventHandler) throws {
        overridenEventHandler = eventHandler
    }

    override func stop() {
        overridenEventHandler = nil
    }
}

class NonRecursiveFolderEventsListener_MockFileWatcherFactory: FileWatcherFactory {
    var mockFileWatcher: FileWatcher!
    var calledPaths: [String]!

    override func fileWatcher(for paths: [String]) -> FileWatcher {
        calledPaths = paths
        return mockFileWatcher
    }
}

class NonRecursiveFolderEventsListenerSpec: QuickSpec {
    override func spec() {
        var fileWatcher: NonRecursiveFolderEventsListener_MockFileWatcher!
        var fileWatcherFactory: NonRecursiveFolderEventsListener_MockFileWatcherFactory!
        var listener: NonRecursiveFolderEventsListener!
        var folderPath: String!
        var output: FolderEventsListenerOutputMock!

        beforeEach {
            output = FolderEventsListenerOutputMock()
            folderPath = "/system/myuser/folderpath"
            fileWatcher = NonRecursiveFolderEventsListener_MockFileWatcher(paths: [], createFlag: [], runLoop: RunLoop.current, latency: 1)
            fileWatcherFactory = NonRecursiveFolderEventsListener_MockFileWatcherFactory()
            fileWatcherFactory.mockFileWatcher = fileWatcher
        }

        describe(".init") {
            beforeEach {
                listener = NonRecursiveFolderEventsListener(folderPath: folderPath, filter: nil, fileWatcherFactory: fileWatcherFactory)
            }

            it("creates a watcher with on the given path") {
                expect(fileWatcherFactory.calledPaths).to(contain(folderPath))
            }

            it("assigns folder path") {
                expect(listener.folderPath).to(equal(folderPath))
            }
        }

        describe(".stopListening") {
            beforeEach {
                listener = NonRecursiveFolderEventsListener(folderPath: folderPath, filter: nil, fileWatcherFactory: fileWatcherFactory)
                listener.output = output
                listener.startListening()
                listener.stopListening()
            }

            it("stops the file watcher") {
                expect(fileWatcher.overridenEventHandler).to(beNil())
            }
        }

        describe(".startListening") {
            context("when there is an event") {
                var event: FileWatcher.Event!

                beforeEach {
                    event = FileWatcher.Event(path: "/path/to/event/file.txt", flag: FileWatcher.EventFlag.ItemCreated.union(FileWatcher.EventFlag.ItemIsFile), eventID: 0)
                }

                context("when there are no filters") {
                    beforeEach {
                        listener = NonRecursiveFolderEventsListener(folderPath: folderPath, filter: nil, fileWatcherFactory: fileWatcherFactory)
                        listener.output = output
                        listener.startListening()
                        fileWatcher.overridenEventHandler?(event)
                    }

                    it("outputs folder event") {
                        expect(output.folderEventsListenerCalled).to(beTrue())
                    }

                    it("outputs correct folder event") {
                        let expectedFolderEvent = FolderEvent.created(path: "/path/to/event/file.txt", object: .file)
                        expect(output.folderEventsListenerReceivedArguments?.1).to(equal(expectedFolderEvent))
                    }
                }

                context("when there are filters") {
                    context("when the event passes the filter") {
                        beforeEach {
                            listener = NonRecursiveFolderEventsListener(folderPath: folderPath, filter: FolderEventFilter.type(.file), fileWatcherFactory: fileWatcherFactory)
                            listener.output = output
                            listener.startListening()
                        }

                        beforeEach {
                            fileWatcher.overridenEventHandler?(event)
                        }

                        it("outputs folder event") {
                            expect(output.folderEventsListenerCalled).to(beTrue())
                        }

                        it("outputs correct folder event") {
                            let expectedFolderEvent = FolderEvent.created(path: "/path/to/event/file.txt", object: .file)
                            expect(output.folderEventsListenerReceivedArguments?.1).to(equal(expectedFolderEvent))
                        }
                    }

                    context("when the event doesn't pass the filter") {
                        beforeEach {
                            listener = NonRecursiveFolderEventsListener(folderPath: folderPath, filter: FolderEventFilter.type(.folder), fileWatcherFactory: fileWatcherFactory)
                            listener.output = output
                            listener.startListening()
                        }

                        beforeEach {
                            fileWatcher.overridenEventHandler?(event)
                        }

                        it("doesn't output folder event") {
                            expect(output.folderEventsListenerCalled).to(beFalse())
                        }
                    }
                }
            }
        }
    }
}
