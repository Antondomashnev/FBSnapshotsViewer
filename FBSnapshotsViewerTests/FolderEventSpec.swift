//
//  FolderEventSpec.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 05/02/2017.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Quick
import Nimble

@testable import FBSnapshotsViewer

class FBSnapshotsViewerSpec: QuickSpec {
    override func spec() {
        context("when file event") {
            var eventFlag: Int!
            
            beforeEach {
                eventFlag = kFSEventStreamEventFlagItemIsFile
            }
            
            context("when modified") {
                it("returns correct folder event") {
                    let event = FolderEvent(systemEvents: eventFlag + kFSEventStreamEventFlagItemModified, at: "/temp")
                    let expectedEvent = FolderEvent.modified(path: "/temp", object: .file)
                    expect(event).to(equal(expectedEvent))
                }
            }
            
            context("when created") {
                it("returns correct folder event") {
                    let event = FolderEvent(systemEvents: eventFlag + kFSEventStreamEventFlagItemCreated, at: "/temp")
                    let expectedEvent = FolderEvent.created(path: "/temp", object: .file)
                    expect(event).to(equal(expectedEvent))
                }
            }
            
            context("when deleted") {
                it("returns correct folder event") {
                    let event = FolderEvent(systemEvents: eventFlag + kFSEventStreamEventFlagItemRemoved, at: "/temp")
                    let expectedEvent = FolderEvent.deleted(path: "/temp", object: .file)
                    expect(event).to(equal(expectedEvent))
                }
            }
        }
        
        context("when folder event") {
            var eventFlag: Int!
            
            beforeEach {
                eventFlag = kFSEventStreamEventFlagItemIsDir
            }
            
            context("when modified") {
                it("returns correct folder event") {
                    let event = FolderEvent(systemEvents: eventFlag + kFSEventStreamEventFlagItemModified, at: "/temp")
                    let expectedEvent = FolderEvent.modified(path: "/temp", object: .folder)
                    expect(event).to(equal(expectedEvent))
                }
            }
            
            context("when created") {
                it("returns correct folder event") {
                    let event = FolderEvent(systemEvents: eventFlag + kFSEventStreamEventFlagItemCreated, at: "/temp")
                    let expectedEvent = FolderEvent.created(path: "/temp", object: .folder)
                    expect(event).to(equal(expectedEvent))
                }
            }
            
            context("when deleted") {
                it("returns correct folder event") {
                    let event = FolderEvent(systemEvents: eventFlag + kFSEventStreamEventFlagItemRemoved, at: "/temp")
                    let expectedEvent = FolderEvent.deleted(path: "/temp", object: .folder)
                    expect(event).to(equal(expectedEvent))
                }
            }
        }
    }
}
