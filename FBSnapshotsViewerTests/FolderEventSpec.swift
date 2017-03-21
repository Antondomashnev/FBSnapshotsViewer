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
        describe(".object") {
            context("when modified") {
                it("returns correct object") {
                    expect(FolderEvent.modified(path: "lala", object: .folder).object).to(equal(FolderEventObject.folder))
                }
            }

            context("when created") {
                it("returns correct object") {
                    expect(FolderEvent.created(path: "lala", object: .file).object).to(equal(FolderEventObject.file))
                }
            }

            context("when deleted") {
                it("returns correct object") {
                    expect(FolderEvent.deleted(path: "lala", object: .folder).object).to(equal(FolderEventObject.folder))
                }
            }

            context("when renamed") {
                it("returns correct object") {
                    expect(FolderEvent.renamed(path: "lala", object: .file).object).to(equal(FolderEventObject.file))
                }
            }

            context("when unknown") {
                it("returns nil") {
                    expect(FolderEvent.unknown.object).to(beNil())
                }
            }
        }

        describe(".path") {
            context("when modified") {
                it("returns correct path") {
                    expect(FolderEvent.modified(path: "foo", object: .folder).path).to(equal("foo"))
                }
            }

            context("when created") {
                it("returns correct path") {
                    expect(FolderEvent.created(path: "buka", object: .file).path).to(equal("buka"))
                }
            }

            context("when deleted") {
                it("returns correct path") {
                    expect(FolderEvent.deleted(path: "lala", object: .folder).path).to(equal("lala"))
                }
            }

            context("when renamed") {
                it("returns correct path") {
                    expect(FolderEvent.renamed(path: "bar", object: .file).path).to(equal("bar"))
                }
            }

            context("when unknown") {
                it("returns nil") {
                    expect(FolderEvent.unknown.path).to(beNil())
                }
            }
        }

        context("when file event") {
            var eventFlag: FileWatcher.EventFlag!

            beforeEach {
                eventFlag = FileWatcher.EventFlag.ItemIsFile
            }

            context("when renamed") {
                it ("returns correct folder event") {
                    let event = FolderEvent(eventFlag: FileWatcher.EventFlag.ItemRenamed.union(eventFlag), at: "/temp")
                    let expectedEvent = FolderEvent.renamed(path: "/temp", object: .file)
                    expect(event).to(equal(expectedEvent))
                }
            }

            context("when modified") {
                it("returns correct folder event") {
                    let event = FolderEvent(eventFlag: FileWatcher.EventFlag.ItemModified.union(eventFlag), at: "/temp")
                    let expectedEvent = FolderEvent.modified(path: "/temp", object: .file)
                    expect(event).to(equal(expectedEvent))
                }
            }

            context("when created") {
                it("returns correct folder event") {
                    let event = FolderEvent(eventFlag: FileWatcher.EventFlag.ItemCreated.union(eventFlag), at: "/temp")
                    let expectedEvent = FolderEvent.created(path: "/temp", object: .file)
                    expect(event).to(equal(expectedEvent))
                }
            }

            context("when deleted") {
                it("returns correct folder event") {
                    let event = FolderEvent(eventFlag: FileWatcher.EventFlag.ItemRemoved.union(eventFlag), at: "/temp")
                    let expectedEvent = FolderEvent.deleted(path: "/temp", object: .file)
                    expect(event).to(equal(expectedEvent))
                }
            }
        }

        context("when folder event") {
            var eventFlag: FileWatcher.EventFlag!

            beforeEach {
                eventFlag = FileWatcher.EventFlag.ItemIsDir
            }

            context("when unknown") {
                it("returns correct folder event") {
                    let event = FolderEvent(eventFlag: FileWatcher.EventFlag.None.union(eventFlag), at: "/temp")
                    let expectedEvent = FolderEvent.unknown
                    expect(event).to(equal(expectedEvent))
                }
            }

            context("when renamed") {
                it("returns correct folder event") {
                    let event = FolderEvent(eventFlag: FileWatcher.EventFlag.ItemRenamed.union(eventFlag), at: "/temp")
                    let expectedEvent = FolderEvent.renamed(path: "/temp", object: .folder)
                    expect(event).to(equal(expectedEvent))
                }
            }

            context("when modified") {
                it("returns correct folder event") {
                    let event = FolderEvent(eventFlag: FileWatcher.EventFlag.ItemModified.union(eventFlag), at: "/temp")
                    let expectedEvent = FolderEvent.modified(path: "/temp", object: .folder)
                    expect(event).to(equal(expectedEvent))
                }
            }

            context("when created") {
                it("returns correct folder event") {
                    let event = FolderEvent(eventFlag: FileWatcher.EventFlag.ItemCreated.union(eventFlag), at: "/temp")
                    let expectedEvent = FolderEvent.created(path: "/temp", object: .folder)
                    expect(event).to(equal(expectedEvent))
                }
            }

            context("when deleted") {
                it("returns correct folder event") {
                    let event = FolderEvent(eventFlag: FileWatcher.EventFlag.ItemRemoved.union(eventFlag), at: "/temp")
                    let expectedEvent = FolderEvent.deleted(path: "/temp", object: .folder)
                    expect(event).to(equal(expectedEvent))
                }
            }
        }
    }
}
