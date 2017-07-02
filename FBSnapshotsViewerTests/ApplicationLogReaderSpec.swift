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
        describe(".readline(of:startingFrom:)") {
            context("when appcode log") {
                let path: String! = Bundle.init(for: type(of: self)).path(forResource: "AppCodeLog", ofType: "xml")
                let log: String! = try? String(contentsOfFile: path)
                var logLines: [ApplicationLogLine] = []
                let configuration: FBSnapshotsViewer.Configuration = FBSnapshotsViewer.Configuration(derivedDataFolder: DerivedDataFolder.appcode(path: "foo/bar"))
                beforeEach {
                    reader = ApplicationLogReader(configuration: configuration)
                }
                context("when without starting line") {
                    it("reads the whole file") {
                        logLines = reader.readline(of: log, startingFrom: 0)
                        expect(logLines.count).to(equal(31))
                        expect(logLines[4]).to(equal(ApplicationLogLine.applicationNameMessage(line: "    <config PASS_PARENT_ENVS_2=\"true\" PROJECT_NAME=\"FBSnapshotsViewerExample\" TARGET_NAME=\"FBSnapshotsViewerExampleTests\" CONFIG_NAME=\"Debug\" SCHEME_NAME=\"FBSnapshotsViewerExampleTests\" TEST_MODE=\"SUITE_TEST\" XCODE_SKIPPED_TESTS_HASH_CODE=\"0\" configId=\"OCUnitRunConfiguration\" name=\"FBSnapshotsViewerExampleTests\" target=\"iphonesimulatoriPhone_7_10.3_x86_64_1\">")))
                        expect(logLines[6]).to(equal(ApplicationLogLine.fbReferenceImageDirMessage(line: "            <env name=\"FB_REFERENCE_IMAGE_DIR\" value=\"/Users/antondomashnev/Work/FBSnapshotsViewerExample/FBSnapshotsViewerExampleTests/ReferenceImages\"/>")))
                        expect(logLines[16]).to(equal(ApplicationLogLine.kaleidoscopeCommandMessage(line: "ksdiff \"/Users/antondomashnev/Library/Developer/CoreSimulator/Devices/B1AC0517-7FC0-4B32-8543-9EC263071FE5/data/Containers/Data/Application/463165DA-5244-400A-87F1-6B5A16441AD7/tmp/FBSnapshotsViewerExampleTests/reference_testFail@2x.png\" \"/Users/antondomashnev/Library/Developer/CoreSimulator/Devices/B1AC0517-7FC0-4B32-8543-9EC263071FE5/data/Containers/Data/Application/463165DA-5244-400A-87F1-6B5A16441AD7/tmp/FBSnapshotsViewerExampleTests/failed_testFail@2x.png\"")))
                        expect(logLines[23]).to(equal(ApplicationLogLine.referenceImageSavedMessage(line: "            <output type=\"stderr\">2017-06-07 22:45:56.604 FBSnapshotsViewerExample[32663:2211488] Reference image save at: /Users/antondomashnev/Work/FBSnapshotsViewerExample/FBSnapshotsViewerExampleTests/ReferenceImages_64/FBSnapshotsViewerExampleTests/testRecord@2x.png")))
                    }
                }
                context("when starting line") {
                    context("out of bounds") {
                        it("skips reading") {
                            expect(reader.readline(of: log, startingFrom: 50).count).to(equal(0))
                        }
                    }
                    context("in range") {
                        it("reads part of the file") {
                            logLines = reader.readline(of: log, startingFrom: 20)
                            expect(logLines.count).to(equal(11))
                            expect(logLines[3]).to(equal(ApplicationLogLine.referenceImageSavedMessage(line: "            <output type=\"stderr\">2017-06-07 22:45:56.604 FBSnapshotsViewerExample[32663:2211488] Reference image save at: /Users/antondomashnev/Work/FBSnapshotsViewerExample/FBSnapshotsViewerExampleTests/ReferenceImages_64/FBSnapshotsViewerExampleTests/testRecord@2x.png")))
                        }
                    }
                }
            }
            context("when xcode log") {
                let path: String! = Bundle.init(for: type(of: self)).path(forResource: "TestLog", ofType: "log")
                let log: String! = try? String(contentsOfFile: path)
                var logLines: [ApplicationLogLine] = []
                let configuration: FBSnapshotsViewer.Configuration = FBSnapshotsViewer.Configuration(derivedDataFolder: DerivedDataFolder.xcodeDefault)
                beforeEach {
                    reader = ApplicationLogReader(configuration: configuration)
                }
                context("when without starting line") {
                    it("reads the whole file") {
                        logLines = reader.readline(of: log, startingFrom: 0)
                        expect(logLines.count).to(equal(288))
                        expect(logLines[49]).to(equal(ApplicationLogLine.fbReferenceImageDirMessage(line: "\"FB_REFERENCE_IMAGE_DIR\" = \"/Users/antondomashnev/Work/FBSnapshotsViewerExample/FBSnapshotsViewerExampleTests/ReferenceImages\";")))
                        expect(logLines[52]).to(equal(ApplicationLogLine.applicationNameMessage(line: "XCInjectBundleInto = \"/Users/antondomashnev/Library/Developer/Xcode/DerivedData/FBSnapshotsViewerExample-eeuapqepwoebslcfqojhfzyfuhmp/Build/Products/Debug-iphonesimulator/FBSnapshotsViewerExample.app/FBSnapshotsViewerExample\";")))
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
}
