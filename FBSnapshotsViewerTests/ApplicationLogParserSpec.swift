//
//  ApplicationLogParserSpec.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 24.04.17.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Quick
import Nimble

@testable import FBSnapshotsViewer

class ApplicationLogParserSpec: QuickSpec {
    override func spec() {
        describe(".parse") {
            let logText: String! = try? String(

            it("founds snapshot test images") {
                expect(logText).toNot(beNil())
            }
        }
    }
}
