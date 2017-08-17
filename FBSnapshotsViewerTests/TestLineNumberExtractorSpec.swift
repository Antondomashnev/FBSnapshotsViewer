//
//  TestLineNumberExtractorSpec.swift
//  FBSnapshotsViewerTests
//
//  Created by Anton Domashnev on 13.08.17.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Quick
import Nimble

@testable import FBSnapshotsViewer

class TestLineNumberExtractorSpec: QuickSpec {
    override func spec() {
        var subject: DefaultTestLineNumberExtractor!
        
        beforeEach {
            subject = DefaultTestLineNumberExtractor()
        }
        
        describe(".extractTestLineNumber") {
            var logLine: ApplicationLogLine!
            
            context("given kaleidoscopeCommandMessage") {
                beforeEach {
                    logLine = ApplicationLogLine.kaleidoscopeCommandMessage(line: "foo/bar")
                }
                
                it("throws") {
                    expect { try subject.extractTestLineNumber(from: logLine) }.to(throwError())
                }
            }
            
            context("given referenceImageSavedMessage") {
                beforeEach {
                    logLine = ApplicationLogLine.referenceImageSavedMessage(line: "foo/bar")
                }
                
                it("throws") {
                    expect { try subject.extractTestLineNumber(from: logLine) }.to(throwError())
                }
            }
            
            context("given applicationNameMessage") {
                beforeEach {
                    logLine = ApplicationLogLine.applicationNameMessage(line: "foo/bar")
                }
                
                it("throws") {
                    expect { try subject.extractTestLineNumber(from: logLine) }.to(throwError())
                }
            }
            
            context("given fbReferenceImageDirMessage") {
                beforeEach {
                    logLine = ApplicationLogLine.fbReferenceImageDirMessage(line: "foo/bar")
                }
                
                it("throws") {
                    expect { try subject.extractTestLineNumber(from: logLine) }.to(throwError())
                }
            }
            
            context("given snapshotTestErrorMessage") {
                context("with valid line") {
                    beforeEach {
                        logLine = ApplicationLogLine.snapshotTestErrorMessage(line: "/Users/antondomashnev/Work/FBSnapshotsViewerExample/FBSnapshotsViewerExampleTests/FBSnapshotsViewerExampleTests.m:38: error: -[FBSnapshotsViewerExampleTests testRecord] : ((noErrors) is true) failed - Snapshot comparison failed: (null)")
                    }
                    
                    it("returns valid test line number") {
                        let testLineNumber = try? subject.extractTestLineNumber(from: logLine)
                        expect(testLineNumber).to(equal(38))
                    }
                }
                
                context("with invalid line") {
                    beforeEach {
                        logLine = ApplicationLogLine.snapshotTestErrorMessage(line: "lalala lalala foo bar")
                    }
                    
                    it("throws") {
                        expect { try subject.extractTestLineNumber(from: logLine) }.to(throwError())
                    }
                }
            }
            
            context("given unknown") {
                beforeEach {
                    logLine = ApplicationLogLine.unknown
                }
                
                it("throws") {
                    expect { try subject.extractTestLineNumber(from: logLine) }.to(throwError())
                }
            }
        }
    }
}
