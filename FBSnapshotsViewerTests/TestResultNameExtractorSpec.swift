//
//  TestResultNameExtractorSpec.swift
//  FBSnapshotsViewer
//
//  Created by Anton Domashnev on 26/02/2017.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import Quick
import Nimble

@testable import FBSnapshotsViewer

class TestResultNameExtractorSpec: QuickSpec {
    override func spec() {
        context("when diff image path") {
            let imagePath = "/Users/myuser/Library/Developer/CoreSimulator/Devices/30D06E4C-C6F4-4F8D-93EC-63381DC42F12/data/Containers/Data/Application/E78B5865-234B-4779-BCED-784C91146583/tmp/FBSnapshotsViewerExampleTests/diff_testExample@2x.png"
            
            it("extracts image name") {
                expect(TestResultNameExtractor.extractTestName(from: imagePath)).to(equal("testExample"))
            }
        }
        
        context("when reference image path") {
            let imagePath = "/Users/myuser/Library/Developer/CoreSimulator/Devices/30D06E4C-C6F4-4F8D-93EC-63381DC42F12/data/Containers/Data/Application/E78B5865-234B-4779-BCED-784C91146583/tmp/FBSnapshotsViewerExampleTests/reference_testExample@2x.png"
            
            it("extracts image name") {
                expect(TestResultNameExtractor.extractTestName(from: imagePath)).to(equal("testExample"))
            }
        }
        
        context("when failed image path") {
            let imagePath = "/Users/myuser/Library/Developer/CoreSimulator/Devices/30D06E4C-C6F4-4F8D-93EC-63381DC42F12/data/Containers/Data/Application/E78B5865-234B-4779-BCED-784C91146583/tmp/FBSnapshotsViewerExampleTests/failed_testExample@2x.png"
            
            it("extracts image name") {
                expect(TestResultNameExtractor.extractTestName(from: imagePath)).to(equal("testExample"))
            }
        }
    }
}
