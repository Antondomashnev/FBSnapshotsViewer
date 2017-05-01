//
//  TestResultsInteractorSpec.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 19/03/2017.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Quick
import Nimble

@testable import FBSnapshotsViewer

class TestResultsInteractorSpec: QuickSpec {
    override func spec() {
        var interactor: TestResultsInteractor!
        var testResults: [SnapshotTestResult] = []

        beforeEach {
            let testResult1 = SnapshotTestResult.failed(testName: "testName1", referenceImagePath: "referenceImagePath1", diffImagePath: "diffImagePath1", failedImagePath: "failedImagePath1")
            let testResult2 = SnapshotTestResult.recorded(testName: "testName2", referenceImagePath: "referenceImagePath2")
            testResults = [testResult1, testResult2]
            interactor = TestResultsInteractor(testResults: testResults)
        }

        describe(".testResults") {
            it("returns initialized test results") {
                expect(interactor.testResults.count).to(equal(2))
            }
        }
    }
}
