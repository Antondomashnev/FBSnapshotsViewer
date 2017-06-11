//
//  TestResultsDisplayInfo.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 11.06.17.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Foundation

struct TestResultsSectionTitleDisplayInfo: AutoEquatable, AutoHashable {
    let title: String
    let timeAgo: String
    
    init(build: Build, testContext: String, dateFormatter: DateComponentsFormatter = DateComponentsFormatter.naturalApproximationFormatter) {
        self.title = "\(build.applicationName) | \(testContext)"
        self.timeAgo = dateFormatter.string(from: build.date, to: Date()) ?? "just now"
    }
}

struct TestResultsSectionDisplayInfo: AutoEquatable {
    let titleInfo: TestResultsSectionTitleDisplayInfo
    let itemInfos: [TestResultDisplayInfo]
    
    init(title: TestResultsSectionTitleDisplayInfo, items: [TestResultDisplayInfo] = []) {
        self.titleInfo = title
        self.itemInfos = items
    }
}
