//
//  ApplicationSnapshotTestImageCollectorSpec.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 18/03/2017.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Quick
import Nimble

@testable import FBSnapshotsViewer

class ApplicationSnapshotTestImageCollectorSpec: QuickSpec {
    override func spec() {
        var collector: ApplicationSnapshotTestImageCollector!
        var output: ApplicationSnapshotTestImageCollectorOutputMock!

        beforeEach {
            output = ApplicationSnapshotTestImageCollectorOutputMock()
            collector = ApplicationSnapshotTestImageCollector()
            collector.output = output
        }

        describe(".collect") {
            context("when collects failed, reference and diff test images") {
                var diffSnapshotTestImage: SnapshotTestImage!
                var failedSnapshotTestImage: SnapshotTestImage!
                var referenceSnapshotTestImage: SnapshotTestImage!

                beforeEach {
                    diffSnapshotTestImage = SnapshotTestImage.diff(imagePath: "diff_testimage@2x.png")
                    failedSnapshotTestImage = SnapshotTestImage.failed(imagePath: "failed_testimage@2x.png")
                    referenceSnapshotTestImage = SnapshotTestImage.reference(imagePath: "reference_testimage@2x.png")
                    collector.collect(diffSnapshotTestImage)
                    collector.collect(failedSnapshotTestImage)
                    collector.collect(referenceSnapshotTestImage)
                }

                it("outputs completed test result") {
                    expect(output.applicationSnapshotTestResultCollectorCalled).to(beTrue())
                }

                it("outputs correct test result") {
                    expect(output.applicationSnapshotTestResultCollectorReceivedArguments?.1.diffImagePath).to(equal("diff_testimage@2x.png"))
                    expect(output.applicationSnapshotTestResultCollectorReceivedArguments?.1.failedImagePath).to(equal("failed_testimage@2x.png"))
                    expect(output.applicationSnapshotTestResultCollectorReceivedArguments?.1.referenceImagePath).to(equal("reference_testimage@2x.png"))
                    expect(output.applicationSnapshotTestResultCollectorReceivedArguments?.1.testName).to(equal("testimage"))
                }
            }
        }
    }
}
