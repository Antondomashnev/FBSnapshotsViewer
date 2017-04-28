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

class ApplicationLogReaderrSpec: QuickSpec {
    override func spec() {
        var reader: ApplicationLogReader!

        beforeEach {
            reader = ApplicationLogReader()
        }

        describe(".read") {
            let path: String! = Bundle.init(for: type(of: self)).path(forResource: "TestLog", ofType: "log")
            let log: String! = try? String(contentsOfFile: path)
            var logLines: [ApplicationLogLine] = []
        }
    }
}
