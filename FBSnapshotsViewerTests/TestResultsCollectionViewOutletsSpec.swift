//
//  TestResultsCollectionViewOutletsSpec.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 20/03/2017.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Quick
import Nimble

@testable import FBSnapshotsViewer

class TestResultsCollectionViewOutletsSpec: QuickSpec {
    override func spec() {
        var collectionView: NSCollectionView!
        var collectionViewOutlets: TestResultsCollectionViewOutlets!

        beforeEach {
            collectionView = NSCollectionView(frame: NSRect(x: 0, y: 0, width: 200, height: 200))
            collectionViewOutlets = TestResultsCollectionViewOutlets(collectionView: collectionView)
        }

        describe(".numberOfSections") {
            it("returns one") {
                expect(collectionViewOutlets.numberOfSections(in: collectionView)).to(equal(1))
            }
        }

        describe(".sizeForItemAt") {
            it("returns correct size") {
                let expectedSize = NSSize(width: 530, height: 346)
                let size = collectionViewOutlets.collectionView(collectionView, layout: NSCollectionViewLayout(), sizeForItemAt: IndexPath(item: 0, section: 0))
                expect(size).to(equal(expectedSize))
            }
        }

        describe(".insetForSectionAt") {
            it("returns correct insets") {
                let expectedInsets = NSEdgeInsetsZero
                let insets = collectionViewOutlets.collectionView(collectionView, layout: NSCollectionViewLayout(), insetForSectionAt: 0)
                expect(insets.bottom).to(equal(expectedInsets.bottom))
                expect(insets.top).to(equal(expectedInsets.top))
                expect(insets.right).to(equal(expectedInsets.right))
                expect(insets.left).to(equal(expectedInsets.left))
            }
        }

        describe(".numberOfItemsInSection") {
            var testResults: [TestResultDisplayInfo] = []

            beforeEach {
                let snapshotTestResult = SnapshotTestResult.failed(testName: "testName", referenceImagePath: "referenceImagePath.png", diffImagePath: "diffImagePath.png", failedImagePath: "failedImagePath.png", createdAt: Date(), applicationName: "MyApp")
                let testResult = TestResultDisplayInfo(testResult: snapshotTestResult)
                testResults = [testResult]
                collectionViewOutlets.testResults = testResults
            }

            it("returns correct number of rows") {
                expect(collectionViewOutlets.collectionView(collectionView, numberOfItemsInSection: 0)).to(equal(1))
            }
        }
    }
}
