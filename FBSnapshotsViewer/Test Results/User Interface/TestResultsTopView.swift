//
//  TestResultsTopView.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 17.06.17.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import AppKit

protocol TestResultsTopViewDelegate: class {
    func testResultsTopView(_ topView: TestResultsTopView, didSelect diffMode: TestResultsDiffMode)
}

class TestResultsTopView: NSView {
    weak var delegate: TestResultsTopViewDelegate?
    
    @IBOutlet private weak var numberOfTestsLabel: NSTextField!
    @IBOutlet private weak var testResultsDiffModeSegementedControl: NSSegmentedControl!
    
    override func draw(_ dirtyRect: NSRect) {
        let gradient = NSGradient(starting: Color(named: .testResultsTopViewColorBottom), ending: Color(named: .testResultsTopViewColorTop))
        gradient?.draw(in: bounds, angle: 90)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        testResultsDiffModeSegementedControl.target = self
        testResultsDiffModeSegementedControl.action = #selector(testResultsDiffModeSegementedControlValueChanged(sender:))
    }
    
    // MARK: - Helpers
    
    private func convertToDiffMode(testResultsDiffModeSegement: Int) -> TestResultsDiffMode {
        return (testResultsDiffModeSegement == 1) ? TestResultsDiffMode.diff : TestResultsDiffMode.mouseOver
    }
    
    private func convertToTestResultsDiffModeSegement(diffMode: TestResultsDiffMode) -> Int {
        return (diffMode == .mouseOver) ? 0 : 1
    }
    
    // MARK: - Interface
    
    func configure(with testResultsDisplayInfo: TestResultsDisplayInfo) {
        numberOfTestsLabel.stringValue = testResultsDisplayInfo.topTitle
        testResultsDiffModeSegementedControl.setSelected(true, forSegment: convertToTestResultsDiffModeSegement(diffMode: testResultsDisplayInfo.testResultsDiffMode))
    }
    
    // MARK: - Actions
    
    @objc func testResultsDiffModeSegementedControlValueChanged(sender: NSSegmentedControl) {
        delegate?.testResultsTopView(self, didSelect: convertToDiffMode(testResultsDiffModeSegement: sender.selectedSegment))
    }
}
