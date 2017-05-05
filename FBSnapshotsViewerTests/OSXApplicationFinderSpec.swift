//
//  OSXApplicationFinderSpec.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 06.05.17.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Quick
import Nimble

@testable import FBSnapshotsViewer

class OSXApplicationFinderSpec: QuickSpec {
    override func spec() {
        var finder: OSXApplicationFinder!

        beforeEach {
            finder = OSXApplicationFinder()
        }

        describe(".findApplication") {
            it("finds application that is installed on the machine") {
                expect(finder.findApplication(with: "com.apple.finder")).toNot(beNil())
            }

            it("doesn't find application that is not installed on the machine") {
                expect(finder.findApplication(with: "com.antondomashnev.fake")).to(beNil())
            }
        }
    }
}
