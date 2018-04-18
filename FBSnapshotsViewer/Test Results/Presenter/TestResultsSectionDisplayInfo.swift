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
    let timeAgoDate: Date
    
    init(build: Build, testContext: String, dateFormatter: DateComponentsFormatter = DateComponentsFormatter.naturalApproximationFormatter) {
        self.title = "\(build.applicationName) | \(testContext)"
        self.timeAgoDate = build.date
        if let timeAgo = dateFormatter.string(from: build.date, to: Date()) {
            self.timeAgo = timeAgo == "About 0 seconds" ? "Just now" : "\(timeAgo) ago"
        }
        else {
            self.timeAgo = "Just now"
        }
    }
    
    init(title: String, timeAgo: String, timeAgoDate: Date) {
        self.title = title
        self.timeAgo = timeAgo
        self.timeAgoDate = timeAgoDate
    }
}

struct TestResultsSectionDisplayInfo: AutoEquatable {
    let titleInfo: TestResultsSectionTitleDisplayInfo
    let itemInfos: [TestResultDisplayInfo]
    
    var hasItemsToAccept: Bool {
        return itemInfos.index { $0.canBeAccepted } != nil ? true : false
    }
    
    init(title: TestResultsSectionTitleDisplayInfo, items: [TestResultDisplayInfo] = []) {
        self.titleInfo = title
        self.itemInfos = items
    }
}
