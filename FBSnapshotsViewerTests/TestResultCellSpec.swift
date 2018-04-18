//
//  TestResultCellSpec.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 07.05.17.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import AppKit
import Quick
import Nimble

@testable import FBSnapshotsViewer

class TestResultCellSpec: QuickSpec {
    override func spec() {
        var cell: TestResultCell!
        var delegate: TestResultCellDelegateMock!

        beforeEach {
            delegate = TestResultCellDelegateMock()
            cell = TestResultCell(nibName: "TestResultCell", bundle: Bundle.main)
            cell.delegate = delegate
        }
        
        describe(".copySnapshotButtonClicked") {
            beforeEach {
                cell.copySnapshotButtonClicked(NSButton(frame: NSRect.zero))
            }
            
            it("calls delegate") {
                expect(delegate.testResultCell___copySnapshotButtonClicked_Called).to(beTrue())
                expect(delegate.testResultCell___copySnapshotButtonClicked_ReceivedArguments?.cell).to(equal(cell))
            }
        }

        describe(".viewInKaleidoscopeButtonClicked") {
            beforeEach {
                cell.viewInKaleidoscopeButtonClicked(NSButton(frame: NSRect.zero))
            }

            it("calls delegate") {
                expect(delegate.testResultCell___viewInKaleidoscopeButtonClicked_Called).to(beTrue())
                expect(delegate.testResultCell___viewInKaleidoscopeButtonClicked_ReceivedArguments?.cell).to(equal(cell))
            }
        }
        
        describe(".viewInXcodeButtonClicked") {
            beforeEach {
                cell.viewInXcodeButtonClicked(NSButton(frame: NSRect.zero))
            }
            
            it("calls delegate") {
                expect(delegate.testResultCell___viewInXcodeButtonClicked_Called).to(beTrue())
                expect(delegate.testResultCell___viewInXcodeButtonClicked_ReceivedArguments?.cell).to(equal(cell))
            }
        }
        
        describe(".acceptSnapshotsButtonClicked") {
            beforeEach {
                cell.acceptSnapshotsButtonClicked(NSButton(frame: NSRect.zero))
            }
            
            it("calls delegate") {
                expect(delegate.testResultCell___acceptSnapshotsButtonClicked_Called).to(beTrue())
                expect(delegate.testResultCell___acceptSnapshotsButtonClicked_ReceivedArguments?.cell).to(equal(cell))
            }
        }
    }
}
