//
//  SnapshotTestImageSpec.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 26/02/2017.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Quick
import Nimble

@testable import FBSnapshotsViewer

class SnapshotTestImageSpec: QuickSpec {
    override func spec() {
        describe(".testName") {
            context("when diff") {
                it("returns correct testName") {
                    let imagePath = "/Users/myuser/Library/Developer/CoreSimulator/Devices/30D06E4C-C6F4-4F8D-93EC-63381DC42F12/data/Containers/Data/Application/E78B5865-234B-4779-BCED-784C91146583/tmp/FBSnapshotsViewerExampleTests/diff_testExample@2x.png"
                    let image = SnapshotTestImage.diff(imagePath: imagePath)
                    expect(image.testName).to(equal("testExample"))
                }
            }
            
            context("when failed") {
                it("returns correct testName") {
                    let imagePath = "/Users/myuser/Library/Developer/CoreSimulator/Devices/30D06E4C-C6F4-4F8D-93EC-63381DC42F12/data/Containers/Data/Application/E78B5865-234B-4779-BCED-784C91146583/tmp/FBSnapshotsViewerExampleTests/failed_testExample@2x.png"
                    let image = SnapshotTestImage.failed(imagePath: imagePath)
                    expect(image.testName).to(equal("testExample"))
                }
            }
            
            context("when reference") {
                it("returns correct testName") {
                    let imagePath = "/Users/myuser/Library/Developer/CoreSimulator/Devices/30D06E4C-C6F4-4F8D-93EC-63381DC42F12/data/Containers/Data/Application/E78B5865-234B-4779-BCED-784C91146583/tmp/FBSnapshotsViewerExampleTests/reference_testExample@2x.png"
                    let image = SnapshotTestImage.reference(imagePath: imagePath)
                    expect(image.testName).to(equal("testExample"))
                }
            }
        }
        
        describe(".init(imagePath)") {
            context("when image is diff") {
                it("returns diff image") {
                    let imagePath = "/Users/myuser/Library/Developer/CoreSimulator/Devices/30D06E4C-C6F4-4F8D-93EC-63381DC42F12/data/Containers/Data/Application/E78B5865-234B-4779-BCED-784C91146583/tmp/FBSnapshotsViewerExampleTests/diff_testExample@2x.png"
                    let expectedImage = SnapshotTestImage.diff(imagePath: imagePath)
                    let testImage = SnapshotTestImage(imagePath: imagePath)
                    expect(testImage).to(equal(expectedImage))
                }
            }
            
            context("when image is reference") {
                it("returns reference image") {
                    let imagePath = "/Users/myuser/Library/Developer/CoreSimulator/Devices/30D06E4C-C6F4-4F8D-93EC-63381DC42F12/data/Containers/Data/Application/E78B5865-234B-4779-BCED-784C91146583/tmp/FBSnapshotsViewerExampleTests/reference_testExample@2x.png"
                    let expectedImage = SnapshotTestImage.reference(imagePath: imagePath)
                    let testImage = SnapshotTestImage(imagePath: imagePath)
                    expect(testImage).to(equal(expectedImage))
                }
            }
            
            context("when image is failed") {
                it("returns failed image") {
                    let imagePath = "/Users/myuser/Library/Developer/CoreSimulator/Devices/30D06E4C-C6F4-4F8D-93EC-63381DC42F12/data/Containers/Data/Application/E78B5865-234B-4779-BCED-784C91146583/tmp/FBSnapshotsViewerExampleTests/failed_testExample@2x.png"
                    let expectedImage = SnapshotTestImage.failed(imagePath: imagePath)
                    let testImage = SnapshotTestImage(imagePath: imagePath)
                    expect(testImage).to(equal(expectedImage))
                }
            }
            
            context("when image is unknown") {
                it("returns nil") {
                    expect(SnapshotTestImage(imagePath: "/Users/myuser/Library/Developer/CoreSimulator/Devices/30D06E4C-C6F4-4F8D-93EC-63381DC42F12/data/Containers/Data/Application/E78B5865-234B-4779-BCED-784C91146583/tmp/FBSnapshotsViewerExampleTests/testExampleWhatever")).to(beNil())
                }
            }
        }
    }
}
