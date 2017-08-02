//
//  StringStripSpec.swift
//  FBSnapshotsViewerTests
//
//  Created by Anton Domashnev on 02.08.17.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Quick
import Nimble

@testable import FBSnapshotsViewer

class StringStripSpec: QuickSpec {
    override func spec() {
        describe(".stripping") {
            it("removed leading and trailing whitespaces") {
                expect("   Hi! I'm John! ".stripping()).to(equal("Hi! I'm John!"))
                expect(" Yo".stripping()).to(equal("Yo"))
                expect("Whats up?! ".stripping()).to(equal("Whats up?!"))
            }
        }
    }
}
