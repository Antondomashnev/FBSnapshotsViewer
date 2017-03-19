//
//  ApplicationSnapshotTestImageCollectorFactorySpec.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 19/03/2017.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Quick
import Nimble

@testable import FBSnapshotsViewer

class ApplicationSnapshotTestImageCollectorFactorySpec: QuickSpec {
    override func spec() {
        var factory: ApplicationSnapshotTestImageCollectorFactory!

        beforeEach {
            factory = ApplicationSnapshotTestImageCollectorFactory()
        }

        describe(".applicationSnapshotTestImageCollector") {
            it("returns correct collector") {
                expect(factory.applicationSnapshotTestImageCollector()).toNot(beNil())
            }
        }
    }
}
