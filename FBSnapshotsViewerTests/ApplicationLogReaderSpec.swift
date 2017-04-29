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

        describe(".readline(of:startingFrom:)") {
            let path: String! = Bundle.init(for: type(of: self)).path(forResource: "TestLog", ofType: "log")
            let log: String! = try? String(contentsOfFile: path)
            var logLines: [ApplicationLogLine] = []

            context("when without starting line") {
                it("reads the whole file") {
                    logLines = reader.readline(of: log, startingFrom: 0)
                    expect(logLines.count).to(equal(288))
                    expect(logLines[247]).to(equal(ApplicationLogLine.kaleidoscopeCommandMessage(line: "ksdiff \"/Users/antondomashnev/Library/Developer/CoreSimulator/Devices/B1AC0517-7FC0-4B32-8543-9EC263071FE5/data/Containers/Data/Application/8EEE157C-41B9-47F8-8634-CF3D60962E19/tmp/FBSnapshotsViewerExampleTests/reference_testFail@2x.png\" \"/Users/antondomashnev/Library/Developer/CoreSimulator/Devices/B1AC0517-7FC0-4B32-8543-9EC263071FE5/data/Containers/Data/Application/8EEE157C-41B9-47F8-8634-CF3D60962E19/tmp/FBSnapshotsViewerExampleTests/failed_testFail@2x.png\"")))
                    expect(logLines[260]).to(equal(ApplicationLogLine.referenceImageSavedMessage(line: "2017-04-25 21:15:37.107 FBSnapshotsViewerExample[56034:787919] Reference image save at: /Users/antondomashnev/Work/FBSnapshotsViewerExample/FBSnapshotsViewerExampleTests/ReferenceImages_64/FBSnapshotsViewerExampleTests/testRecord@2x.png")))
                }
            }

            context("when starting line") {
                context("out of bounds") {
                    it("skips reading") {
                        expect(reader.readline(of: log, startingFrom: 5000).count).to(equal(0))
                    }
                }

                context("in range") {
                    it("reads part of the file") {
                        logLines = reader.readline(of: log, startingFrom: 255)
                        expect(logLines.count).to(equal(33))
                        expect(logLines[5]).to(equal(ApplicationLogLine.referenceImageSavedMessage(line: "2017-04-25 21:15:37.107 FBSnapshotsViewerExample[56034:787919] Reference image save at: /Users/antondomashnev/Work/FBSnapshotsViewerExample/FBSnapshotsViewerExampleTests/ReferenceImages_64/FBSnapshotsViewerExampleTests/testRecord@2x.png")))
                    }
                }
            }
        }
    }
}
