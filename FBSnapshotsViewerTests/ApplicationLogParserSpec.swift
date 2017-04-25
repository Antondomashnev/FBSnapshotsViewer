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
        var parser: ApplicationLogParser!

        beforeEach {
            parser = ApplicationLogParser()
        }

        describe(".parse") {
            let path: String! = Bundle.init(for: type(of: self)).path(forResource: "TestLog", ofType: "log")
            let log: String! = try? String(contentsOfFile: path)
            var snapshotTestResults: [SnapshotTestResult] = []

            beforeEach {
                snapshotTestResults = parser.parse(log: log)
            }

            it("parses the recorded snapshot test result") {
                let expectedResult = SnapshotTestResult.recorded(testName: "testRecord", referenceImagePath: "/Users/antondomashnev/Work/FBSnapshotsViewerExample/FBSnapshotsViewerExampleTests/ReferenceImages_64/FBSnapshotsViewerExampleTests/testRecord@2x.png")
                expect(snapshotTestResults[1]).to(equal(expectedResult))
            }
        }
    }
}
