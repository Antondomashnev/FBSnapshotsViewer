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
        var testResultsSections: [TestResultsSectionDisplayInfo] = []
        var testResultsDisplayInfo: TestResultsDisplayInfo!

        beforeEach {
            let build1 = Build(date: Date(), applicationName: "MyApp", fbReferenceImageDirectoryURL:  URL(fileURLWithPath: "foo/bar", isDirectory: true))
            let snapshotTestResult1 = SnapshotTestResult.failed(testInformation: SnapshotTestInformation(testClassName: "testClassName", testName: "testName"), referenceImagePath: "referenceImagePath.png", diffImagePath: "diffImagePath.png", failedImagePath: "failedImagePath.png", build: build1)
            let testResult1 = TestResultDisplayInfo(testResult: snapshotTestResult1)
            let sectionTitle1 = TestResultsSectionTitleDisplayInfo(build: build1, testContext: "Context1")
            let section1 = TestResultsSectionDisplayInfo(title: sectionTitle1, items: [testResult1])
            
            let build2 = Build(date: Date(), applicationName: "MyApp", fbReferenceImageDirectoryURL:  URL(fileURLWithPath: "foo/bar", isDirectory: true))
            let snapshotTestResult2 = SnapshotTestResult.failed(testInformation: SnapshotTestInformation(testClassName: "testClassName", testName: "testName"), referenceImagePath: "referenceImagePath.png", diffImagePath: "diffImagePath.png", failedImagePath: "failedImagePath.png", build: build2)
            let testResult2 = TestResultDisplayInfo(testResult: snapshotTestResult2)
            let snapshotTestResult3 = SnapshotTestResult.failed(testInformation: SnapshotTestInformation(testClassName: "testClassName", testName: "testName"), referenceImagePath: "referenceImagePath.png", diffImagePath: "diffImagePath.png", failedImagePath: "failedImagePath.png", build: build2)
            let testResult3 = TestResultDisplayInfo(testResult: snapshotTestResult3)
            let sectionTitle2 = TestResultsSectionTitleDisplayInfo(build: build2, testContext: "Context2")
            let section2 = TestResultsSectionDisplayInfo(title: sectionTitle2, items: [testResult2, testResult3])
            testResultsSections = [section1, section2]
            testResultsDisplayInfo = TestResultsDisplayInfo(sectionInfos: testResultsSections, testResultsDiffMode: .mouseOver)
            
            collectionView = NSCollectionView(frame: NSRect(x: 0, y: 0, width: 200, height: 200))
            collectionViewOutlets = TestResultsCollectionViewOutlets(collectionView: collectionView)
            collectionViewOutlets.testResultsDisplayInfo = testResultsDisplayInfo
        }

        describe(".numberOfSections") {
            it("returns one") {
                expect(collectionViewOutlets.numberOfSections(in: collectionView)).to(equal(2))
            }
        }

        describe(".sizeForItemAt") {
            it("returns correct size") {
                let expectedSize = NSSize(width: 732, height: 408)
                let size = collectionViewOutlets.collectionView(collectionView, layout: NSCollectionViewLayout(), sizeForItemAt: IndexPath(item: 0, section: 0))
                expect(size).to(equal(expectedSize))
            }
        }
        
        describe(".referenceSizeForHeaderInSection") {
            it("returns correct size") {
                let expectedSize = NSSize(width: 732, height: 30)
                let size = collectionViewOutlets.collectionView(collectionView, layout: NSCollectionViewLayout(), referenceSizeForHeaderInSection: 0)
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
        
        describe(".minimumInteritemSpacingForSectionAt") {
            it("returns correct spacing") {
                let spacing = collectionViewOutlets.collectionView(collectionView, layout: NSCollectionViewLayout(), minimumInteritemSpacingForSectionAt: 0)
                expect(spacing).to(equal(0))
            }
        }
        
        describe(".minimumLineSpacingForSectionAt") {
            it("returns correct spacing") {
                let spacing = collectionViewOutlets.collectionView(collectionView, layout: NSCollectionViewLayout(), minimumLineSpacingForSectionAt: 0)
                expect(spacing).to(equal(0))
            }
        }

        describe(".numberOfItemsInSection") {
            it("returns correct number of rows") {
                expect(collectionViewOutlets.collectionView(collectionView, numberOfItemsInSection: 0)).to(equal(1))
                expect(collectionViewOutlets.collectionView(collectionView, numberOfItemsInSection: 1)).to(equal(2))
            }
        }
    }
}
