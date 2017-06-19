//
//  TestResultsDisplayInfo.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 17.06.17.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Foundation

struct TestResultsDisplayInfo: AutoEquatable {
    let sectionInfos: [TestResultsSectionDisplayInfo]
    let topTitle: String
    let testResultsDiffMode: TestResultsDiffMode

    init(sectionInfos: [TestResultsSectionDisplayInfo] = [], testResultsDiffMode: TestResultsDiffMode = .mouseOver) {
        self.sectionInfos = sectionInfos
        self.testResultsDiffMode = testResultsDiffMode
        let numberOfTests = sectionInfos.reduce(0, { $0 + $1.itemInfos.count })
        self.topTitle = "\(numberOfTests) Test Result" + (numberOfTests > 1 ? "s" : "")
    }
}
