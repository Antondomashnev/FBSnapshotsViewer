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
    var overridenEventHandler: EventHandler!
    
    override func start(with eventHandler: @escaping FileWatcher.EventHandler) throws {
        overridenEventHandler = eventHandler
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

        beforeEach {
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
        
        describe(".startListening") {
            beforeEach {
                listener = NonRecursiveFolderEventsListener(folderPath: folderPath, filter: nil, fileWatcherFactory: fileWatcherFactory)
                listener.startListening()
            }
            
            context("when there is an event") {
                context("when there are no filters") {
                    beforeEach {
                        fileWatcher.eventHandler?()
                    }
                }
            }
        }
    }
}
