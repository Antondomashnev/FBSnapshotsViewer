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

        describe(".viewInKaleidoscopeButtonClicked") {
            beforeEach {
                cell.viewInKaleidoscopeButtonClicked(NSButton(frame: NSRect.zero))
            }

            it("calls delegate") {
                expect(delegate.testResultCellCalled).to(beTrue())
                expect(delegate.testResultCellReceivedArguments?.cell).to(equal(cell))
            }
        }
    }
}
