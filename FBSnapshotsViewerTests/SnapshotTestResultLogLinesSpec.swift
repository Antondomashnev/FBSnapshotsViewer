//
//  SnapshotTestResultLogLinesSpec.swift
//  FBSnapshotsViewerTests
//
//  Created by Anton Domashnev on 15.08.17.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Quick
import Nimble

@testable import FBSnapshotsViewer

class SnapshotTestResultLogLinesSpec: QuickSpec {
    override func spec() {
        var subject: SnapshotTestResultLogLines!
        
        describe(".init") {
            context("given snapshotTestErrorMessage as errorLogLine") {
                var errorLogLine: ApplicationLogLine!
                var resultLogLine: ApplicationLogLine!
                
                beforeEach {
                    errorLogLine = ApplicationLogLine.snapshotTestErrorMessage(line: "foo/bar")
                }
                
                context("given kaleidoscopeCommandMessage as resultLogLine") {
                    beforeEach {
                        resultLogLine = ApplicationLogLine.kaleidoscopeCommandMessage(line: "foo/baz")
                    }
                    
                    it("initializes new log lines instance") {
                        expect(SnapshotTestResultLogLines(resultLogLine: resultLogLine, errorLogLine: errorLogLine)).toNot(beNil())
                    }
                }
                
                context("given referenceImageSavedMessage as resultLogLine") {
                    beforeEach {
                        resultLogLine = ApplicationLogLine.referenceImageSavedMessage(line: "foo/baz")
                    }
                    
                    it("initializes new log lines instance") {
                        expect(SnapshotTestResultLogLines(resultLogLine: resultLogLine, errorLogLine: errorLogLine)).toNot(beNil())
                    }
                }
                
                context("given applicationNameMessage as resultLogLine") {
                    beforeEach {
                        resultLogLine = ApplicationLogLine.applicationNameMessage(line: "foo/baz")
                    }
                    
                    it("returns nil") {
                        expect(SnapshotTestResultLogLines(resultLogLine: resultLogLine, errorLogLine: errorLogLine)).to(beNil())
                    }
                }
                
                context("given fbReferenceImageDirMessage as resultLogLine") {
                    beforeEach {
                        resultLogLine = ApplicationLogLine.fbReferenceImageDirMessage(line: "foo/baz")
                    }
                    
                    it("returns nil") {
                        expect(SnapshotTestResultLogLines(resultLogLine: resultLogLine, errorLogLine: errorLogLine)).to(beNil())
                    }
                }
                
                context("given unknown as resultLogLine") {
                    beforeEach {
                        resultLogLine = ApplicationLogLine.unknown
                    }
                    
                    it("returns nil") {
                        expect(SnapshotTestResultLogLines(resultLogLine: resultLogLine, errorLogLine: errorLogLine)).to(beNil())
                    }
                }
            }
            
            context("given not snapshotTestErrorMessage as errorLogLine") {
                var resultLogLine: ApplicationLogLine!
                
                beforeEach {
                    resultLogLine = ApplicationLogLine.kaleidoscopeCommandMessage(line: "lalala")
                }
                
                it("returns nil") {
                    expect(SnapshotTestResultLogLines(resultLogLine: resultLogLine, errorLogLine: ApplicationLogLine.kaleidoscopeCommandMessage(line: "lalala"))).to(beNil())
                    expect(SnapshotTestResultLogLines(resultLogLine: resultLogLine, errorLogLine: ApplicationLogLine.referenceImageSavedMessage(line: "lalala"))).to(beNil())
                    expect(SnapshotTestResultLogLines(resultLogLine: resultLogLine, errorLogLine: ApplicationLogLine.applicationNameMessage(line: "lalala"))).to(beNil())
                    expect(SnapshotTestResultLogLines(resultLogLine: resultLogLine, errorLogLine: ApplicationLogLine.fbReferenceImageDirMessage(line: "lalala"))).to(beNil())
                    expect(SnapshotTestResultLogLines(resultLogLine: resultLogLine, errorLogLine: ApplicationLogLine.unknown)).to(beNil())
                }
            }
        }
        
        describe(".resultMessage") {
            context("for recordedSnapshotTestResultLines") {
                beforeEach {
                    subject = SnapshotTestResultLogLines.recordedSnapshotTestResultLines("foo/bar", "baz/bar")
                }
                
                it("returns correct string") {
                    expect(subject.resultMessage).to(equal("foo/bar"))
                }
            }
            
            context("for failedSnapshotTestResultLines") {
                beforeEach {
                    subject = SnapshotTestResultLogLines.failedSnapshotTestResultLines("foo/bar", "baz/bar")
                }
                
                it("returns correct string") {
                    expect(subject.resultMessage).to(equal("foo/bar"))
                }
            }
        }
        
        describe(".errorMessage") {
            context("for recordedSnapshotTestResultLines") {
                beforeEach {
                    subject = SnapshotTestResultLogLines.recordedSnapshotTestResultLines("foo/bar", "baz/bar")
                }
                
                it("returns correct string") {
                    expect(subject.errorMessage).to(equal("baz/bar"))
                }
            }
            
            context("for failedSnapshotTestResultLines") {
                beforeEach {
                    subject = SnapshotTestResultLogLines.failedSnapshotTestResultLines("foo/bar", "baz/bar")
                }
                
                it("returns correct string") {
                    expect(subject.errorMessage).to(equal("baz/bar"))
                }
            }
        }
    }
}
