//
//  StringHTMLSpec.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 20.05.17.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Quick
import Nimble

@testable import FBSnapshotsViewer

class StringHTMLSpec: QuickSpec {
    override func spec() {
        describe(".htmlUnescape") {
            let string = "ksdiff &amp;quot;/Users/antondomashnev/Library/Developer/CoreSimulator/Devices/B1AC0517-7FC0-4B32-8543-9EC263071FE5/data/Containers/Data/Application/B7F3D96D-B20C-486D-98A4-85D6889AF6AD/tmp/FBSnapshotsViewerExampleTests/reference_testFail@2x.png&amp;quot; &amp;quot;/Users/antondomashnev/Library/Developer/CoreSimulator/Devices/B1AC0517-7FC0-4B32-8543-9EC263071FE5/data/Containers/Data/Application/B7F3D96D-B20C-486D-98A4-85D6889AF6AD/tmp/FBSnapshotsViewerExampleTests/failed_testFail@2x.png&amp;quot;"

            it("unescapes the string") {
                let expectedString = "ksdiff \"/Users/antondomashnev/Library/Developer/CoreSimulator/Devices/B1AC0517-7FC0-4B32-8543-9EC263071FE5/data/Containers/Data/Application/B7F3D96D-B20C-486D-98A4-85D6889AF6AD/tmp/FBSnapshotsViewerExampleTests/reference_testFail@2x.png\" \"/Users/antondomashnev/Library/Developer/CoreSimulator/Devices/B1AC0517-7FC0-4B32-8543-9EC263071FE5/data/Containers/Data/Application/B7F3D96D-B20C-486D-98A4-85D6889AF6AD/tmp/FBSnapshotsViewerExampleTests/failed_testFail@2x.png\""
                expect(string.htmlUnescape()).to(equal(expectedString))
            }
        }
    }
}
