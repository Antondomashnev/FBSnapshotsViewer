//
//  FolderEventFilterSpec.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 13/03/2017.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Quick
import Nimble

@testable import FBSnapshotsViewer

class FolderEventFilterSpec: QuickSpec {
    override func spec() {
        describe(".apply") {
            context("when known filter") {
                it("filters unknown events") {
                    expect(FolderEventFilter.known.apply(to: FolderEvent.unknown)).to(beFalse())
                    expect(FolderEventFilter.known.apply(to: FolderEvent.created(path: "path1", object: .folder))).to(beTrue())
                    expect(FolderEventFilter.known.apply(to: FolderEvent.renamed(path: "path2", object: .file))).to(beTrue())
                    expect(FolderEventFilter.known.apply(to: FolderEvent.deleted(path: "path1", object: .folder))).to(beTrue())
                    expect(FolderEventFilter.known.apply(to: FolderEvent.modified(path: "path2", object: .file))).to(beTrue())
                }
            }

            context("when type filder") {
                it("filters by type") {
                    expect(FolderEventFilter.type(.file).apply(to: FolderEvent.unknown)).to(beFalse())
                    expect(FolderEventFilter.type(.file).apply(to: FolderEvent.created(path: "path1", object: .folder))).to(beFalse())
                    expect(FolderEventFilter.type(.folder).apply(to: FolderEvent.deleted(path: "path1", object: .folder))).to(beTrue())
                }
            }

            context("when path regex") {
                it("filters using regular expression on path") {
                    let filter = FolderEventFilter.pathRegex("(diff)_.+\\.png$")
                    expect(filter.apply(to: FolderEvent.unknown)).to(beFalse())
                    expect(filter.apply(to: FolderEvent.created(path: "testuser/documents/project/tests/diff_myimage.png", object: .folder))).to(beTrue())
                    expect(filter.apply(to: FolderEvent.deleted(path: "testuser/documents/project/tests/diffmyimage.png", object: .folder))).to(beFalse())
                    expect(filter.apply(to: FolderEvent.modified(path: "testuser/documents/project/tests/_myimage.png", object: .folder))).to(beFalse())
                    expect(filter.apply(to: FolderEvent.renamed(path: "testuser/documents/project/tests/diff_myimage.jpg", object: .folder))).to(beFalse())
                }
            }

            context("when compound") {
                it("sums up two filters") {
                    let filter1 = FolderEventFilter.pathRegex("(diff)_.+\\.png$")
                    let filter2 = FolderEventFilter.type(.file)
                    let resultFilter = filter1 & filter2
                    expect(resultFilter.apply(to: FolderEvent.created(path: "testuser/documents/project/tests/diff_myimage.png", object: .folder))).to(beFalse())
                    expect(resultFilter.apply(to: FolderEvent.created(path: "testuser/documents/project/tests/myimage.png", object: .folder))).to(beFalse())
                    expect(resultFilter.apply(to: FolderEvent.created(path: "testuser/documents/project/tests/myimage.png", object: .file))).to(beFalse())
                    expect(resultFilter.apply(to: FolderEvent.created(path: "testuser/documents/project/tests/diff_myimage.png", object: .file))).to(beTrue())
                }
            }
        }
    }
}
