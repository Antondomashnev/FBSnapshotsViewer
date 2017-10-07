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
        fdescribe(".readline(of:startingFrom:)") {
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
                        expect(logLines[18]).to(equal(ApplicationLogLine.snapshotTestErrorMessage(line: "/Users/antondomashnev/Work/FBSnapshotsViewerExample/FBSnapshotsViewerExampleTests/FBSnapshotsViewerExampleTests.m:27: error: -[FBSnapshotsViewerExampleTests testFail] : ((noErrors) is true) failed - Snapshot comparison failed: Error Domain=FBSnapshotTestControllerErrorDomain Code=4 \"Images different\" UserInfo={NSLocalizedFailureReason=image pixels differed by more than 0.00% from the reference image, FBDiffedImageKey=<UIImage: 0x6000000876c0>, {375, 667}, FBReferenceImageKey=<UIImage: 0x60000048e510>, {375, 667}, FBCapturedImageKey=<UIImage: 0x600000085d20>, {375, 667}, NSLocalizedDescription=Images different}")))
                        expect(logLines[23]).to(equal(ApplicationLogLine.referenceImageSavedMessage(line: "            <output type=\"stderr\">2017-06-07 22:45:56.604 FBSnapshotsViewerExample[32663:2211488] Reference image save at: /Users/antondomashnev/Work/FBSnapshotsViewerExample/FBSnapshotsViewerExampleTests/ReferenceImages_64/FBSnapshotsViewerExampleTests/testRecord@2x.png")))
                        expect(logLines[25]).to(equal(ApplicationLogLine.snapshotTestErrorMessage(line: "/Users/antondomashnev/Work/FBSnapshotsViewerExample/FBSnapshotsViewerExampleTests/FBSnapshotsViewerExampleTests.m:38: error: -[FBSnapshotsViewerExampleTests testRecord] : ((noErrors) is true) failed - Snapshot comparison failed: (null)")))
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
                var logLines: [ApplicationLogLine] = []
                let configuration: FBSnapshotsViewer.Configuration = FBSnapshotsViewer.Configuration(derivedDataFolder: DerivedDataFolder.xcodeDefault)
                
                beforeEach {
                    logLines = []
                    reader = ApplicationLogReader(configuration: configuration)
                }
                
                context("generated by ios-snapshot-test-case version 2.1.4") {
                    let path: String! = Bundle.init(for: type(of: self)).path(forResource: "TestLog", ofType: "log")
                    let log: String! = try? String(contentsOfFile: path)
                    
                    context("when without starting line") {
                        it("reads the whole file") {
                            logLines = reader.readline(of: log, startingFrom: 0)
                            expect(logLines.count).to(equal(288))
                            expect(logLines[49]).to(equal(ApplicationLogLine.fbReferenceImageDirMessage(line: "\"FB_REFERENCE_IMAGE_DIR\" = \"/Users/antondomashnev/Work/FBSnapshotsViewerExample/FBSnapshotsViewerExampleTests/ReferenceImages\";")))
                            expect(logLines[52]).to(equal(ApplicationLogLine.applicationNameMessage(line: "XCInjectBundleInto = \"/Users/antondomashnev/Library/Developer/Xcode/DerivedData/FBSnapshotsViewerExample-eeuapqepwoebslcfqojhfzyfuhmp/Build/Products/Debug-iphonesimulator/FBSnapshotsViewerExample.app/FBSnapshotsViewerExample\";")))
                            expect(logLines[247]).to(equal(ApplicationLogLine.kaleidoscopeCommandMessage(line: "ksdiff \"/Users/antondomashnev/Library/Developer/CoreSimulator/Devices/B1AC0517-7FC0-4B32-8543-9EC263071FE5/data/Containers/Data/Application/8EEE157C-41B9-47F8-8634-CF3D60962E19/tmp/FBSnapshotsViewerExampleTests/reference_testFail@2x.png\" \"/Users/antondomashnev/Library/Developer/CoreSimulator/Devices/B1AC0517-7FC0-4B32-8543-9EC263071FE5/data/Containers/Data/Application/8EEE157C-41B9-47F8-8634-CF3D60962E19/tmp/FBSnapshotsViewerExampleTests/failed_testFail@2x.png\"")))
                            expect(logLines[248]).to(equal(ApplicationLogLine.snapshotTestErrorMessage(line: "/Users/antondomashnev/Work/FBSnapshotsViewerExample/FBSnapshotsViewerExampleTests/FBSnapshotsViewerExampleTests.m:27: error: -[FBSnapshotsViewerExampleTests testFail] : ((noErrors) is true) failed - Snapshot comparison failed: Error Domain=FBSnapshotTestControllerErrorDomain Code=4 \"Images different\" UserInfo={NSLocalizedFailureReason=image pixels differed by more than 0.00% from the reference image, FBDiffedImageKey=<UIImage: 0x6000002909a0>, {375, 667}, FBReferenceImageKey=<UIImage: 0x60000028fff0>, {375, 667}, FBCapturedImageKey=<UIImage: 0x600000290950>, {375, 667}, NSLocalizedDescription=Images different}")))
                            expect(logLines[260]).to(equal(ApplicationLogLine.referenceImageSavedMessage(line: "2017-04-25 21:15:37.107 FBSnapshotsViewerExample[56034:787919] Reference image save at: /Users/antondomashnev/Work/FBSnapshotsViewerExample/FBSnapshotsViewerExampleTests/ReferenceImages_64/FBSnapshotsViewerExampleTests/testRecord@2x.png")))
                            expect(logLines[261]).to(equal(ApplicationLogLine.snapshotTestErrorMessage(line: "/Users/antondomashnev/Work/FBSnapshotsViewerExample/FBSnapshotsViewerExampleTests/FBSnapshotsViewerExampleTests.m:38: error: -[FBSnapshotsViewerExampleTests testRecord] : ((noErrors) is true) failed - Snapshot comparison failed: (null)")))
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
                
                context("generated by ios-snapshot-test-case master") {
                    let path: String! = Bundle.init(for: type(of: self)).path(forResource: "TestLogMasterVersion", ofType: "log")
                    let log: String! = try? String(contentsOfFile: path)
                    
                    context("when without starting line") {
                        it("reads the whole file") {
                            logLines = reader.readline(of: log, startingFrom: 0)
                            expect(logLines.count).to(equal(308))
                            expect(logLines[49]).to(equal(ApplicationLogLine.fbReferenceImageDirMessage(line: "        \"FB_REFERENCE_IMAGE_DIR\" = \"/Users/antondomashnev/privatesource/FBSnapshotsViewerTest/FBSnapshotsViewerTestTests/ReferenceImages\";")))
                            expect(logLines[53]).to(equal(ApplicationLogLine.applicationNameMessage(line: "        XCInjectBundleInto = \"/Users/antondomashnev/Library/Developer/Xcode/DerivedData/FBSnapshotsViewerTest-cfwggbrdbrgmeqglezgseksycblm/Build/Products/Debug-iphonesimulator/FBSnapshotsViewerTest.app/FBSnapshotsViewerTest\";")))
                            expect(logLines[237]).to(equal(ApplicationLogLine.kaleidoscopeCommandMessage(line: "ksdiff \"/Users/antondomashnev/Library/Developer/CoreSimulator/Devices/9C43B57E-D84A-4295-8C68-E30098B1A2E2/data/Containers/Data/Application/0A43508A-692A-4C0E-860B-D032A45BDD62/tmp/FBSnapshotsViewerTestTests.FBSnapshotsViewerTestTests/reference_testExample2@2x.png\" \"/Users/antondomashnev/Library/Developer/CoreSimulator/Devices/9C43B57E-D84A-4295-8C68-E30098B1A2E2/data/Containers/Data/Application/0A43508A-692A-4C0E-860B-D032A45BDD62/tmp/FBSnapshotsViewerTestTests.FBSnapshotsViewerTestTests/failed_testExample2@2x.png\"")))
                            expect(logLines[238]).to(equal(ApplicationLogLine.snapshotTestErrorMessage(line: "/Users/antondomashnev/privatesource/FBSnapshotsViewerTest/FBSnapshotsViewerTestTests/FBSnapshotsViewerTestTests.swift:33: error: -[FBSnapshotsViewerTestTests.FBSnapshotsViewerTestTests testExample2] : failed - Snapshot comparison failed: Optional(Error Domain=FBSnapshotTestControllerErrorDomain Code=4 \"Images different\" UserInfo={NSLocalizedFailureReason=image pixels differed by more than 0.00% from the reference image, FBDiffedImageKey=<UIImage: 0x6080000bcda0>, {64, 64}, FBReferenceImageKey=<UIImage: 0x6000000bc500>, {64, 64}, FBCapturedImageKey=<UIImage: 0x6000000bc680>, {64, 64}, NSLocalizedDescription=Images different})")))
                            expect(logLines[239]).to(equal(ApplicationLogLine.referenceImageSavedMessage(line: "2017-10-07 11:24:48.361941+0100 FBSnapshotsViewerTest[84009:5050923] Reference image save at: /Users/antondomashnev/privatesource/FBSnapshotsViewerTest/FBSnapshotsViewerTestTests/ReferenceImages_64/FBSnapshotsViewerTestTests.FBSnapshotsViewerTestTests/testExample@2x.png")))
                            expect(logLines[240]).to(equal(ApplicationLogLine.snapshotTestErrorMessage(line: "/Users/antondomashnev/privatesource/FBSnapshotsViewerTest/FBSnapshotsViewerTestTests/FBSnapshotsViewerTestTests.swift:27: error: -[FBSnapshotsViewerTestTests.FBSnapshotsViewerTestTests testExample] : failed - Test ran in record mode. Reference image is now saved. Disable record mode to perform an actual snapshot comparison!11:18:53.919 Xcode[55173:4886155] <IDETestOperationCoordinator: 0x7f9879f35ed0>: parseConsoleOutputFromOriginalOutput: called, 961 bytes written out to StandardOutputAndStandardError")))
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
                                logLines = reader.readline(of: log, startingFrom: 239)
                                expect(logLines.count).to(equal(69))
                                expect(logLines[0]).to(equal(ApplicationLogLine.referenceImageSavedMessage(line: "2017-10-07 11:24:48.361941+0100 FBSnapshotsViewerTest[84009:5050923] Reference image save at: /Users/antondomashnev/privatesource/FBSnapshotsViewerTest/FBSnapshotsViewerTestTests/ReferenceImages_64/FBSnapshotsViewerTestTests.FBSnapshotsViewerTestTests/testExample@2x.png")))
                            }
                        }
                    }
                }
            }
        }
    }
}
