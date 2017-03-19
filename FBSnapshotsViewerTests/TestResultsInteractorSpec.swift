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
        var testResults: [TestResult] = []

        beforeEach {
            let testResult1 = CompletedTestResult(referenceImagePath: "referenceImagePath1", diffImagePath: "diffImagePath1", failedImagePath: "failedImagePath1", testName: "testName1")
            let testResult2 = CompletedTestResult(referenceImagePath: "referenceImagePath2", diffImagePath: "diffImagePath2", failedImagePath: "failedImagePath2", testName: "testName2")
            testResults = [testResult1, testResult2]
            interactor = TestResultsInteractor(testResults: testResults)
        }

        describe(".testResults") {
            it("returns initialized test results") {
                expect(interactor.testResults[0].referenceImagePath).to(equal("referenceImagePath1"))
                expect(interactor.testResults[0].diffImagePath).to(equal("diffImagePath1"))
                expect(interactor.testResults[0].failedImagePath).to(equal("failedImagePath1"))
                expect(interactor.testResults[0].testName).to(equal("testName1"))
                expect(interactor.testResults[1].referenceImagePath).to(equal("referenceImagePath2"))
                expect(interactor.testResults[1].diffImagePath).to(equal("diffImagePath2"))
                expect(interactor.testResults[1].failedImagePath).to(equal("failedImagePath2"))
                expect(interactor.testResults[1].testName).to(equal("testName2"))
            }
        }
    }
}
