//
//  ApplicationLogParserSpec.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 24.04.17.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Quick
import Nimble
import Foundation

@testable import FBSnapshotsViewer

class ApplicationLogParserSpec: QuickSpec {
    override func spec() {
        describe(".parse") {
            let path: String! = Bundle.init(for: type(of: self)).path(forResource: "TestLog", ofType: "log")
            let log: String! = try? String(contentsOfFile: path)

            it("founds snapshot test images") {
                let snapshotImages = ApplicationLogParser.parse(log: log)
                expect()
            }
        }
    }
}
