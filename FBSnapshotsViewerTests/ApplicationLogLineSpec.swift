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
            
            context("when line with FB_REFERENCE_IMAGE_DIR environment variable") {
                let line = "\"FB_REFERENCE_IMAGE_DIR\" = \"/Users/antondomashnev/Work/FBSnapshotsViewerExample/FBSnapshotsViewerExampleTests/ReferenceImages\";"
                
                it("returns fbReferenceImageDirMessage log line") {
                    expect(ApplicationLogLine(line: line)).to(equal(ApplicationLogLine.fbReferenceImageDirMessage(line: line)))
                }
            }
            
            context("when line with failed snapshot test error") {
                let line = "/Users/antondomashnev/Work/FBSnapshotsViewerExample/FBSnapshotsViewerExampleTests/FBSnapshotsViewerExampleTests.m:27: error: -[FBSnapshotsViewerExampleTests testFail] : ((noErrors) is true) failed - Snapshot comparison failed: Error Domain=FBSnapshotTestControllerErrorDomain Code=4 &amp;quot;Images different&amp;quot; UserInfo={NSLocalizedFailureReason=image pixels differed by more than 0.00% from the reference image, FBDiffedImageKey=&amp;lt;UIImage: 0x6000000876c0&amp;gt;, {375, 667}, FBReferenceImageKey=&amp;lt;UIImage: 0x60000048e510&amp;gt;, {375, 667}, FBCapturedImageKey=&amp;lt;UIImage: 0x600000085d20&amp;gt;, {375, 667}, NSLocalizedDescription=Images different}"
                
                it("returns snapshotTestErrorMessage log line") {
                    expect(ApplicationLogLine(line: line)).to(equal(ApplicationLogLine.snapshotTestErrorMessage(line: line)))
                }
            }

            context("when line with failed snapshot test error") {
                let line = "/Users/paultaykalo/Projects/product/ios-app/MyProJectSnapshotTests/ProductTypeCellTests.swift:32: error: -[MyProJectSnapshotTests.ProductTypeCellTests testGenerateMockupForUnknownProductType] : failed - Snapshot comparison failed: Optional(Error Domain=FBSnapshotTestControllerErrorDomain Code=4 \"Images different\" UserInfo={NSLocalizedFailureReason=image pixels differed by more than 0.00% from the reference image, FBDiffedImageKey=<UIImage: 0x61000008e8d0> size {400, 400} orientation 0 scale 2.000000, FBReferenceImageKey=<UIImage: 0x618000092f20> size {400, 400} orientation 0 scale 2.000000, FBCapturedImageKey=<UIImage: 0x6080004991e0> size {400, 400} orientation 0 scale 2.000000, NSLocalizedDescription=Images different})"

                it("returns snapshotTestErrorMessage log line") {
                    expect(ApplicationLogLine(line: line)).to(equal(ApplicationLogLine.snapshotTestErrorMessage(line: line)))
                }
            }

            context("when line with recorded snapshot test error") {
                let line = "/Users/antondomashnev/Work/FBSnapshotsViewerExample/FBSnapshotsViewerExampleTests/FBSnapshotsViewerExampleTests.m:38: error: -[FBSnapshotsViewerExampleTests testRecord] : ((noErrors) is true) failed - Snapshot comparison failed: (null)"
                
                it("returns snapshotTestErrorMessage log line") {
                    expect(ApplicationLogLine(line: line)).to(equal(ApplicationLogLine.snapshotTestErrorMessage(line: line)))
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
