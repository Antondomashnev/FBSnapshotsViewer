//
//  FolderEventsListenerFactorySpec.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 19/03/2017.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Quick
import Nimble

@testable import FBSnapshotsViewer

class FolderEventsListenerFactorySpec: QuickSpec {
    override func spec() {
        var factory: FolderEventsListenerFactory!

        beforeEach {
            factory = FolderEventsListenerFactory()
        }

        describe(".snapshotsDiffFolderEventsListener") {
            it("returns correct listener") {
                expect(factory.snapshotsDiffFolderEventsListener(at: "mypath") is RecursiveFolderEventsListener).to(beTrue())
            }
        }

        describe(".iOSSimulatorApplicationsFolderEventsListener") {
            it("returns correct listener") {
                expect(factory.iOSSimulatorApplicationsFolderEventsListener(at: "mypath") is NonRecursiveFolderEventsListener).to(beTrue())
            }
        }
    }
}
