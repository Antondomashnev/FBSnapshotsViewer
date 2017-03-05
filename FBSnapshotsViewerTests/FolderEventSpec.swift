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

class FolderEventSpec: QuickSpec {
    override func spec() {
        context("when file event") {
            var eventFlag: FileWatch.EventFlag!

            beforeEach {
                eventFlag = FileWatch.EventFlag.ItemIsFile
            }

            context("when renamed") {
                it ("returns correct folder event") {
                    let event = FolderEvent(eventFlag: FileWatch.EventFlag.ItemRenamed.union(eventFlag), at: "/temp")
                    let expectedEvent = FolderEvent.renamed(path: "/temp", object: .file)
                    expect(event).to(equal(expectedEvent))
                }
            }

            context("when modified") {
                it("returns correct folder event") {
                    let event = FolderEvent(eventFlag: FileWatch.EventFlag.ItemModified.union(eventFlag), at: "/temp")
                    let expectedEvent = FolderEvent.modified(path: "/temp", object: .file)
                    expect(event).to(equal(expectedEvent))
                }
            }

            context("when created") {
                it("returns correct folder event") {
                    let event = FolderEvent(eventFlag: FileWatch.EventFlag.ItemCreated.union(eventFlag), at: "/temp")
                    let expectedEvent = FolderEvent.created(path: "/temp", object: .file)
                    expect(event).to(equal(expectedEvent))
                }
            }

            context("when deleted") {
                it("returns correct folder event") {
                    let event = FolderEvent(eventFlag: FileWatch.EventFlag.ItemRemoved.union(eventFlag), at: "/temp")
                    let expectedEvent = FolderEvent.deleted(path: "/temp", object: .file)
                    expect(event).to(equal(expectedEvent))
                }
            }
        }

        context("when folder event") {
            var eventFlag: FileWatch.EventFlag!

            beforeEach {
                eventFlag = FileWatch.EventFlag.ItemIsDir
            }

            context("when renamed") {
                it("returns correct folder event") {
                    let event = FolderEvent(eventFlag: FileWatch.EventFlag.ItemRenamed.union(eventFlag), at: "/temp")
                    let expectedEvent = FolderEvent.renamed(path: "/temp", object: .folder)
                    expect(event).to(equal(expectedEvent))
                }
            }

            context("when modified") {
                it("returns correct folder event") {
                    let event = FolderEvent(eventFlag: FileWatch.EventFlag.ItemModified.union(eventFlag), at: "/temp")
                    let expectedEvent = FolderEvent.modified(path: "/temp", object: .folder)
                    expect(event).to(equal(expectedEvent))
                }
            }

            context("when created") {
                it("returns correct folder event") {
                    let event = FolderEvent(eventFlag: FileWatch.EventFlag.ItemCreated.union(eventFlag), at: "/temp")
                    let expectedEvent = FolderEvent.created(path: "/temp", object: .folder)
                    expect(event).to(equal(expectedEvent))
                }
            }

            context("when deleted") {
                it("returns correct folder event") {
                    let event = FolderEvent(eventFlag: FileWatch.EventFlag.ItemRemoved.union(eventFlag), at: "/temp")
                    let expectedEvent = FolderEvent.deleted(path: "/temp", object: .folder)
                    expect(event).to(equal(expectedEvent))
                }
            }
        }
    }
}
