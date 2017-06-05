//
//  ApplicationLogLineSpec.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 29.04.17.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Quick
import Nimble

@testable import FBSnapshotsViewer

class ApplicationLogLineSpec: QuickSpec {
    override func spec() {
        describe("init(line:)") {
            context("when line with the kaleidoscope command to check failed snapshot test") {
                let line = "ksdiff \"/Users/antondomashnev/Library/Developer/CoreSimulator/Devices/B1AC0517-7FC0-4B32-8543-9EC263071FE5/data/Containers/Data/Application/8EEE157C-41B9-47F8-8634-CF3D60962E19/tmp/FBSnapshotsViewerExampleTests/reference_testFail@2x.png\" \"/Users/antondomashnev/Library/Developer/CoreSimulator/Devices/B1AC0517-7FC0-4B32-8543-9EC263071FE5/data/Containers/Data/Application/8EEE157C-41B9-47F8-8634-CF3D60962E19/tmp/FBSnapshotsViewerExampleTests/failed_testFail@2x.png\""

                it("returns referenceImageSavedMessage log line") {
                    expect(ApplicationLogLine(line: line)).to(equal(ApplicationLogLine.kaleidoscopeCommandMessage(line: line)))
                }
            }

            context("when line with the reference to recorded image") {
                let line = "2017-04-25 21:15:37.107 FBSnapshotsViewerExample[56034:787919] Reference image save at: /Users/antondomashnev/Work/FBSnapshotsViewerExample/FBSnapshotsViewerExampleTests/ReferenceImages_64/FBSnapshotsViewerExampleTests/testRecord@2x.png"

                it("returns referenceImageSavedMessage log line") {
                    expect(ApplicationLogLine(line: line)).to(equal(ApplicationLogLine.referenceImageSavedMessage(line: line)))
                }
            }

            context("when line with the XCInjectBundleInto environment variable") {
                let line = "XCInjectBundleInto = \"/Users/antondomashnev/Library/Developer/Xcode/DerivedData/FBSnapshotsViewerExample-eeuapqepwoebslcfqojhfzyfuhmp/Build/Products/Debug-iphonesimulator/FBSnapshotsViewerExample.app/FBSnapshotsViewerExample\";"

                it("returns applicationNameMessage log line") {
                    expect(ApplicationLogLine(line: line)).to(equal(ApplicationLogLine.applicationNameMessage(line: line)))
                }
            }

            context("when random line") {
                let line = "21:15:27.395 Xcode[4221:116855] Beginning test session FBSnapshotsViewerExampleTests-C6CA3D7B-D217-41C0-8B95-2E9C49ECA4C2 at 2017-04-25 21:15:27.395 with Xcode 8E2002 on target <DVTiPhoneSimulator: 0x7fc33b1b9300> {"

                it("returns unknown") {
                    expect(ApplicationLogLine(line: line)).to(equal(ApplicationLogLine.unknown))
                }
            }
        }
    }
}
