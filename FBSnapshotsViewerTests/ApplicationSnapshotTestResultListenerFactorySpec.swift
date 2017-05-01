//
//  ApplicationSnapshotTestResultListenerFactorySpec.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 26.04.17.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Quick
import Nimble

@testable import FBSnapshotsViewer

class ApplicationSnapshotTestResultListenerFactorySpec: QuickSpec {
    override func spec() {
        var factory: ApplicationSnapshotTestResultListenerFactory!

        beforeEach {
            factory = ApplicationSnapshotTestResultListenerFactory()
        }

        describe(".applicationSnapshotTestResultListener") {
            it("returns new listener") {
                expect(factory.applicationSnapshotTestResultListener(forLogFileAt: "Users/antondomashnev/Library/log.log")).toNot(beNil())
            }
        }
    }
}
