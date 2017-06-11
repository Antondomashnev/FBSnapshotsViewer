//
//  TestResultsSectionTitleDisplayInfoSpec.swift
//  FBSnapshotsViewerTests
//
//  Created by Anton Domashnev on 11.06.17.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Quick
import Nimble

@testable import FBSnapshotsViewer

class TestResultsSectionTitleDisplayInfo_MockDateComponentsFormatter: DateComponentsFormatter {
    var formattedValue: String?
    override func string(from startDate: Date, to endDate: Date) -> String? {
        return formattedValue
    }
}

class TestResultsSectionTitleDisplayInfoSpec: QuickSpec {
    override func spec() {
        var build: Build!
        var dateFormatter: TestResultsSectionTitleDisplayInfo_MockDateComponentsFormatter!
        var displayInfo: TestResultsSectionTitleDisplayInfo!
        
        beforeEach {
            build = Build(date: Date(), applicationName: "FBSnapshotsViewer")
            dateFormatter = TestResultsSectionTitleDisplayInfo_MockDateComponentsFormatter()
        }
        
        describe(".init") {
            beforeEach {
                displayInfo = TestResultsSectionTitleDisplayInfo(build: build, testContext: "TestContext", dateFormatter: dateFormatter)
            }
            
            it("initializes correct title") {
                expect(displayInfo.title).to(equal("FBSnapshotsViewer | TestContext"))
            }
            
            context("when date can be formatter") {
                beforeEach {
                    dateFormatter.formattedValue = "10 minutes ago"
                    displayInfo = TestResultsSectionTitleDisplayInfo(build: build, testContext: "TestContext", dateFormatter: dateFormatter)
                }
                
                it("initializes correct timeAgo") {
                    expect(displayInfo.timeAgo).to(equal("10 minutes ago"))
                }
            }
            
            context("when date can not be formatter") {
                beforeEach {
                    dateFormatter.formattedValue = nil
                    displayInfo = TestResultsSectionTitleDisplayInfo(build: build, testContext: "TestContext", dateFormatter: dateFormatter)
                }
                
                it("initializes correct timeAgo") {
                    expect(displayInfo.timeAgo).to(equal("just now"))
                }
            }
        }
    }
}
